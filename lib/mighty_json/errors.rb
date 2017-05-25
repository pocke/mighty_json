module MightyJSON
  class Error < StandardError
    attr_reader :path, :type, :value

    def initialize(path:, type:, value:)
      @path = path
      @type = type
      @value = value
    end

    def to_s
      position = path.empty? ? "" : " at .#{path.join('.')}"
      "Expected type of value #{value}#{position} is #{type}"
    end
    alias message to_s
  end

  class IllegalTypeError < StandardError
    attr_reader :type

    def initialize(type:)
      @type = type
    end

    def to_s
      "#{type} can not be put on toplevel"
    end
    alias message to_s
  end

  class UnexpectedFieldError < StandardError
    attr_reader :path, :value

    def initialize(path: , value:)
      @path = path
      @value = value
    end

    def to_s
      position = "#{path.join('.')}"
      "Unexpected field of #{position} (#{value})"
    end
    alias message to_s
  end
end
