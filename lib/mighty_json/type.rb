module MightyJSON
  module Type
    NONE = Object.new

    class Base
      def initialize(type)
        @type = type
      end

      def compile(var:, path:)
        v = var.cur
        err = "(raise Error.new(value: #{v}, type: #{self.to_s.inspect}, path: #{path.inspect}))"
        case @type
        when :ignored
          if path == []
            'raise IllegalTypeError.new(type: :ignored)'
          else
            'none'
          end
        when :any
          v
        when :number
          <<~END
            #{v}.is_a?(Numeric) ?
              #{v} :
              #{err}
          END
        when :string
          <<~END
            #{v}.is_a?(String) ?
              #{v} :
              #{err}
          END
        when :boolean
          <<~END
            #{v} == true || #{v} == false ?
              #{v} :
              #{err}
          END
        when :numeric
          <<~END
            #{v}.is_a?(Numeric) || (#{v}.is_a?(String) && /\\A[-+]?[\\d.]+\\Z/ =~ #{v}) ?
              #{v} :
              #{err}
          END
        when :symbol
          <<~END
            #{v}.is_a?(Symbol) ?
              #{v} :
              #{err}
          END
        else
          err
        end
      end

      def to_s
        @type.to_s
      end
    end

    class Optional
      def initialize(type)
        @type = type
      end

      def compile(var:, path:)
        v = var.cur
        <<~END
          if #{v}.nil? || none.equal?(#{v})
            nil
          else
            #{@type.compile(var: var, path: path)}
          end
        END
      end

      def to_s
        "optinal(#{@type})"
      end
    end

    class Literal
      def initialize(value)
        @value = value
      end

      def to_s
        "literal(#{@value})"
      end

      def compile(var:, path:)
        v = var.cur
        <<~END
          raise Error.new(path: #{path.inspect}, type: #{self.to_s.inspect}, value: #{v}) unless #{@value.inspect} == #{v}
          #{v}
        END
      end
    end

    class Array
      def initialize(type)
        @type = type
      end

      def compile(var:, path:)
        v = var.cur
        child = var.next
        <<~END
          begin
            raise Error.new(path: #{path.inspect}, type: #{self.to_s.inspect}, value: #{v}) unless #{v}.is_a?(::Array)
            #{v}.map.with_index do |#{child}, i|
              #{@type.compile(var: var, path: path + [:array_index])}
            end
          end
        END
      end

      def to_s
        "array(#{@type})"
      end
    end

    class Object
      def initialize(fields)
        @fields = fields
      end

      def compile(var:, path:)
        v = var.cur
        keys = @fields.keys.map(&:inspect)

        result = var.next
        <<~END
          begin
            raise Error.new(path: #{path}, type: #{self.to_s.inspect}, value: object) unless #{v}.is_a?(Hash)

            {}.tap do |#{result}|
              #{v}.each do |key, value|
                next if #{keys.map{|key| "#{key} == key"}.join('||')}
                raise UnexpectedFieldError.new(path: #{path.inspect} + [key], value: #{v}) # TOOD: optimize path
              end

              #{
                @fields.map do |key, type|
                  new_var = var.next
                  <<~END2
                    #{new_var} = #{v}.key?(#{key.inspect}) ? #{v}[#{key.inspect}] : none
                    v = #{type.compile(var: var, path: path + [key])}
                    if !none.equal?(v) &&
                       #{!NONE.equal?(type)} &&
                       !(#{type.is_a?(Optional)} && none.equal?(#{new_var}))
                      #{result}[#{key.inspect}] = v
                    end
                  END2
                end.join("\n")
              }
            end
          end
        END
      end

      def to_s
        fields = []

        @fields.each do |name, type|
          fields << "#{name}: #{type}"
        end

        "object(#{fields.join(', ')})"
      end
    end

    class Enum
      attr_reader :types

      def initialize(types)
        @types = types
      end

      def compile(var:, path:)
        v = var.cur
        <<~END
          #{@types.map do |type|
            <<~END2.chomp
              begin
                #{type.compile(var: var, path: path)}
              rescue Error, UnexpectedFieldError, IllegalTypeError
              end
            END2
          end.join(' || ')} || (raise Error.new(path: #{path.inspect}, type: #{self.to_s.inspect}, value: #{v}))
        END
      end

      def to_s
        "enum(#{types.map(&:to_s).join(", ")})"
      end
    end
  end
end
