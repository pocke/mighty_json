require "mighty_json/version"

module MightyJSON
  def initialize(&block)
    instance_eval(&block)
  end

  def let(name, type)
    define_singleton_method(name) { type }
  end

  include MightyJSON::Types
end
