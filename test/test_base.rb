require 'test_helper'

class TestBase < Minitest::Test
  def test_ignored
    m = MightyJSON.new do
      let :test, ignored
    end

    assert_raises(MightyJSON::IllegalTypeError){m.test.coerce(3)}
  end

  def test_number
    m = MightyJSON.new do
      let :test, number
    end

    assert{m.test.coerce(123) == 123}
    assert{m.test.coerce(1.23) == 1.23}
    assert_raises(MightyJSON::Error){m.test.coerce("foo")}
    assert_raises(MightyJSON::Error){m.test.coerce("10")}
    assert_raises(MightyJSON::Error){m.test.coerce("1.1")}
  end

  def test_string
    m = MightyJSON.new do
      let :test, string
    end

    assert{m.test.coerce('foo') == 'foo'}
    assert{m.test.coerce('1') == '1'}
    assert_raises(MightyJSON::Error){m.test.coerce(1)}
  end

  def test_any
    m = MightyJSON.new do
      let :test, any
    end

    assert{m.test.coerce('foo') == 'foo'}
    assert{m.test.coerce(1) == 1}
    assert{m.test.coerce(nil) == nil}
  end

  def test_boolean
    m = MightyJSON.new do
      let :test, boolean
    end

    assert{m.test.coerce(true) == true}
    assert{m.test.coerce(false) == false}
    assert_raises(MightyJSON::Error){m.test.coerce(1)}
    assert_raises(MightyJSON::Error){m.test.coerce(nil)}
    assert_raises(MightyJSON::Error){m.test.coerce('true')}
  end

  def test_numeric
    m = MightyJSON.new do
      let :test, numeric
    end

    assert{m.test.coerce(42) == 42}
    assert{m.test.coerce(4.2) == 4.2}
    assert{m.test.coerce("42") == "42"}
    assert{m.test.coerce("-42") == "-42"}
    assert{m.test.coerce("+42") == "+42"}
    assert{m.test.coerce("4.2") == "4.2"}
    assert_raises(MightyJSON::Error){m.test.coerce('foo')}
    assert_raises(MightyJSON::Error){m.test.coerce('foo1')}
    assert_raises(MightyJSON::Error){m.test.coerce('42foo')}
    assert_raises(MightyJSON::Error){m.test.coerce(nil)}
    assert_raises(MightyJSON::Error){m.test.coerce([])}
  end

  def test_symbol
    m = MightyJSON.new do
      let :test, symbol
    end

    assert{m.test.coerce(:foo) == :foo}
    assert{m.test.coerce(:'a-b') == :'a-b'}
    assert{m.test.coerce(:+) == :+}
    assert{m.test.coerce(:'あ') == :'あ'}
    assert{m.test.coerce(:'\\') == :'\\'}
    assert_raises(MightyJSON::Error){m.test.coerce('foo')}
    assert_raises(MightyJSON::Error){m.test.coerce(42)}
    
  end
end
