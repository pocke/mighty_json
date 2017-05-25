require 'test_helper'

class TestLiteral < Minitest::Test
  def test_integer_literal
    s = MightyJSON.new do
      let :test, literal(1)
    end

    assert{s.test.coerce(1) == 1}
    assert{s.test.coerce(1) == 1.0}
    assert_raises(MightyJSON::Error){s.test.coerce(3)}
  end

  def test_string_literal
    s = MightyJSON.new do
      let :test, literal('foo')
      let :cat, literal('にゃーん')
    end

    assert{s.test.coerce('foo') == 'foo'}
    assert{s.cat.coerce('にゃーん') == 'にゃーん'}
    assert_raises(MightyJSON::Error){s.test.coerce(3)}
    assert_raises(MightyJSON::Error){s.test.coerce({})}
    assert_raises(MightyJSON::Error){s.cat.coerce('ねこ')}
  end
end
