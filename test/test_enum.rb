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

  def test_enum_with_nil
    m = MightyJSON.new do
      let :test, enum(number, literal(nil))
    end

    assert{m.test.coerce(1) == 1}
    assert{m.test.coerce(nil) == nil}
    assert_raises(MightyJSON::Error){m.test.coerce('foo')}
    assert_raises(MightyJSON::Error){m.test.coerce([1])}
  end

  def test_enum_with_object
    m = MightyJSON.new do
      let :test, enum(object(foo: string, bar: object(baz: number)), object(foo: number, bar: object(baz: string)))
    end

    assert{m.test.coerce({foo: 'hoge', bar: {baz: 42}}) == {foo: 'hoge', bar: {baz: 42}}}
    assert{m.test.coerce({foo: 42, bar: {baz: 'hoge'}}) == {foo: 42, bar: {baz: 'hoge'}}}
    assert_raises(MightyJSON::Error){m.test.coerce('foo')}
    assert_raises(MightyJSON::Error){m.test.coerce([1])}
  end
end
