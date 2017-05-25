require 'test_helper'

class TestJSON < Minitest::Test
  def test_json
    s = MightyJSON.new do
      let :item, object(name: string, count: numeric, price: numeric, comment: ignored)
      let :checkout, object(items: array(item), change: optional(number), type: enum(literal(1), symbol))
    end

    assert do
      s.checkout.coerce(items: [ { name: "test", count: 1, price: "2.33", comment: "dummy" }], type: 1) == {items: [ { name: "test", count: 1, price: "2.33", comment: "dummy" }], type: 1}
    end
  end
end
