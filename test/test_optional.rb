require 'test_helper'

class TestOptional < Minitest::Test
  def test_optional
    s = MightyJSON.new do
      let :test, object(a: number?)
    end

    assert{s.test.coerce(a: 1) == {a: 1}}
    assert{s.test.coerce(a: nil) == {a: nil}}
    assert_raises(MightyJSON::Error){s.test.coerce(a: false)}
    assert_raises(MightyJSON::Error){s.test.coerce(a: 'foo')}
  end
end
