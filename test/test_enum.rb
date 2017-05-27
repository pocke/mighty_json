# frozen_string_literal: true

require 'test_helper'

class TestBase < Minitest::Test
  def test_enum
    m = MightyJSON.new do
      let :test, enum(number, string)
    end

    assert{m.test.coerce(1) == 1}
    assert{m.test.coerce('foo') == 'foo'}
    assert_raises(MightyJSON::Error){m.test.coerce(nil)}
    assert_raises(MightyJSON::Error){m.test.coerce([1])}
  end
end
