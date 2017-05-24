class MightyJSON
  module Types
    def object(fields = {})
      Type::Object.new(fields)
    end

    def array(type = any)
      Type::Array.new(type)
    end

    def optional(type = any)
      Type::Optional.new(type)
    end

    def string
      MightyJSON::Type::Base.new(:string)
    end

    def numeric
      MightyJSON::Type::Base.new(:numeric)
    end

    def number
      MightyJSON::Type::Base.new(:number)
    end

    def boolean
      MightyJSON::Type::Base.new(:boolean)
    end

    def any
      MightyJSON::Type::Base.new(:any)
    end

    def prohibited
      MightyJSON::Type::Base.new(:prohibited)
    end

    def symbol
      MightyJSON::Type::Base.new(:symbol)
    end

    def literal(value)
      MightyJSON::Type::Literal.new(value)
    end

    def enum(*types)
      MightyJSON::Type::Enum.new(types)
    end

    def string?
      optional(string)
    end

    def numeric?
      optional(numeric)
    end

    def number?
      optional(number)
    end

    def boolean?
      optional(boolean)
    end

    def symbol?
      optional(symbol)
    end

    def ignored
      MightyJSON::Type::Base.new(:ignored)
    end

    def array?(ty)
      optional(array(ty))
    end

    def object?(fields)
      optional(object(fields))
    end

    def literal?(value)
      optional(literal(value))
    end
  end
end
