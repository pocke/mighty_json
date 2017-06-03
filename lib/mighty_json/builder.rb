# frozen_string_literal: true

require "mighty_json/version"

module MightyJSON
  class Builder
    NONE = Type::NONE
    def initialize(&block)
      @lets = {}
      instance_eval(&block)
    end

    def compile💪💪💪
      Struct.new(*@lets.keys).new(
        *@lets.values.map do |type|
          Object.new.tap do |this|
            var = Variable.new
            v = var.cur
            eval <<~END
              def this.coerce(#{v})
                _none = NONE
                #{type.compile(var: var, path: [])}
              end

              def this.=~(value)
                coerce(value)
                true
              rescue Error, IllegalTypeError, UnexpectedFieldError
                false
              end

              def this.===(value)
                coerce(value)
                true
              rescue Error, IllegalTypeError, UnexpectedFieldError
                false
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
