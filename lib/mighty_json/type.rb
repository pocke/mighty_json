# frozen_string_literal: true

module MightyJSON
  module Type
    NONE = Object.new

    class Eval
      def initialize(code)
        @code = code
      end

      def inspect
        @code
      end
    end

    class Base
      attr_reader :type

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
            '_none'
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
          match = RUBY_VERSION >= '2.4' ?
            ".match?(#{v})" :
            " =~ #{v}"
          <<~END
            #{v}.is_a?(Numeric) || (#{v}.is_a?(String) && /\\A[-+]?[\\d.]+\\Z/#{match}) ?
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
          if #{v}.nil? || _none.equal?(#{v})
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
        idx = var.next
        child = var.next
        <<~END
          begin
            raise Error.new(path: #{path.inspect}, type: #{self.to_s.inspect}, value: #{v}) unless #{v}.is_a?(::Array)
            #{v}.map.with_index do |#{child}, #{idx}|
              #{@type.compile(var: var, path: path + [Eval.new(idx)])}
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
        keys = @fields.keys.map(&:inspect)

        cur = var.cur
        is_fixed = @fields.values.none?{|type| type.is_a?(Optional) || (type.is_a?(Base) && type.type == :ignored)}

        <<~END
          begin
            raise Error.new(path: #{path}, type: #{self.to_s.inspect}, value: #{cur}) unless #{cur}.is_a?(Hash)

            #{"if #{@fields.size} != #{cur}.size" if is_fixed}
              #{cur}.each do |key, value|
                next if #{keys.map{|key| "#{key} == key"}.join('||')}
                raise UnexpectedFieldError.new(path: #{path.inspect} + [key], value: #{cur}) # TOOD: optimize path
              end
            #{'end' if is_fixed}

            #{is_fixed ?
              compile_fixed(var: var, path: path) :
              compile_not_fixed(var: var, path: path)
            }
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

      private

      def compile_fixed(var:, path:)
        cur = var.cur
        <<~END
          {
            #{
              @fields.map do |key, type|
                new_var = var.next
                <<~END2.chomp
                  #{key.inspect} => begin
                    #{new_var} = #{cur}.fetch(#{key.inspect}, _none)
                    #{type.compile(var: var, path: path + [key])}
                  end
                END2
              end.join(",\n")
            }
          }
        END
      end

      def compile_not_fixed(var:, path:)
        cur = var.cur
        result = var.next
        <<~END
          {}.tap do |#{result}|
            #{
              @fields.map do |key, type|
                new_var = var.next
                <<~END2
                  #{new_var} = #{cur}.fetch(#{key.inspect}, _none)
                  v = #{type.compile(var: var, path: path + [key])}
                  if !_none.equal?(v) &&
                     #{!NONE.equal?(type)} &&
                     !(#{type.is_a?(Optional)} && _none.equal?(#{new_var}))
                    #{result}[#{key.inspect}] = v
                  end
                END2
              end.join("\n")
            }
          end
        END
      end
    end

    class Enum
      attr_reader :types

      def initialize(types)
        @types = types
      end

      def compile(var:, path:)
        compile_types(@types, var: var, path: path)
      end

      def to_s
        "enum(#{types.map(&:to_s).join(", ")})"
      end

      private

      def compile_types(types, var:, path:)
        if types.empty?
          v = var.cur
          return "(raise Error.new(path: #{path.inspect}, type: #{self.to_s.inspect}, value: #{v}))"
        end

        <<~END
          begin
            #{types.first.compile(var: var.branch, path: path)}
          rescue Error, UnexpectedFieldError, IllegalTypeError
            #{compile_types(types[1..-1], var: var, path: path)}
          end
        END
      end
    end
  end
end
