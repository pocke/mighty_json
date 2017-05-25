require "mighty_json/version"

module MightyJSON
  class Builder
    def initialize(&block)
      @lets = {}
      instance_eval(&block)
    end

    def compile💪💪💪
      Struct.new(*@lets.keys).new(
        *@lets.values.map do |type|
          Object.new.tap do |this|
            eval <<~END
              def this.coerce(value)
                var0 = value
                #{type.compile(var: 'var0', path: [])}
              end
            END
          end
        end
      )
    end

    def let(name, type)
      @lets[name] = type
      define_singleton_method(name) { type }
    end

    include MightyJSON::Types
  end
end
