require 'test_helper'

class TestObject < Minitest::Test
  def test_object
    s = MightyJSON.new do
      let :test, object(a: numeric, b: string)
    end

    assert{s.test.coerce(a: 1, b: 'foo') == {a: 1, b: 'foo'}}
    assert_raises(MightyJSON::Error){s.test.coerce(a: 'foo', b: 1)}
  end

  def test_object_with_ignored
    s = MightyJSON.new do
      let :test, object(a: numeric, b: ignored)
    end

    assert{s.test.coerce(a: 1, b: 'foo') == {a: 1}}
    assert{s.test.coerce(a: 1) == {a: 1}}
    assert_raises(MightyJSON::Error){s.test.coerce(a: 'foo', b: 1)}
    assert_raises(MightyJSON::Error){s.test.coerce({})}
    assert_raises(MightyJSON::UnexpectedFieldError){s.test.coerce(a: 'foo', c: 1)}
  end

  def test_object_with_optional
    s = MightyJSON.new do
      let :test, object(a: number?, b: string)
    end

    assert{s.test.coerce(a: 1, b: 'foo') == {a: 1, b: 'foo'}}
    assert{s.test.coerce({b: 'foo'}) == {b: 'foo'}}
    assert{s.test.coerce({a: nil, b: 'foo'}) == {a: nil, b: 'foo'}}
    assert_raises(MightyJSON::Error){s.test.coerce(a: 'foo')}
  end
end
