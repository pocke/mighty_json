require 'test_helper'

class TestArray < Minitest::Test
  def test_empty
    m = MightyJSON.new do
      let :test, array(any)
    end

    assert {m.test.coerce([]) == []}
  end

  def test_number
    m = MightyJSON.new do
      let :test, array(number)
    end

    assert {m.test.coerce([42]) == [42]}
  end

  def test_array_of_array_of_number
    m = MightyJSON.new do
      let :test, array(array(number))
    end

    assert {m.test.coerce([[42]]) == [[42]]}
  end

  def test_non_array
    m = MightyJSON.new do
      let :test, array(number)
    end

    assert_raises(MightyJSON::Error) {m.test.coerce({a: 42})}
  end

  def test_membership
    m = MightyJSON.new do
      let :test, array(number)
    end

    assert_raises(MightyJSON::Error) {m.test.coerce(['foo'])}
    assert_raises(MightyJSON::Error) {m.test.coerce([1, 'foo'])}
  end

  def test_nil
    m = MightyJSON.new do
      let :test, array(number)
    end

    assert_raises(MightyJSON::Error) {m.test.coerce([nil])}
    assert_raises(MightyJSON::Error) {m.test.coerce(nil)}
    assert_raises(MightyJSON::Error) {m.test.coerce([1, nil])}
  end

  def test_bacon_cannon_op
    m = MightyJSON.new do
      let :test, array(number)
    end

    assert {(m.test =~ [1]) == true}
    assert {(m.test =~ []) == true}
    assert {(m.test =~ ['foo']) == false}
  end

  def test_error_message
    m = MightyJSON.new do
      let :test, object(foo: array(array(string)))
    end

    ex = assert_raises(MightyJSON::Error) {m.test.coerce({foo: [['1'], ['1', 4]]})}
    assert{ex.message == 'Expected type of value 4 at .foo.1.1 is string'}

    ex = assert_raises(MightyJSON::Error) {m.test.coerce({foo: [['1'], ['1', '2'], ['4', '5', '6', 7, '8']]})}
    assert{ex.message == 'Expected type of value 7 at .foo.2.3 is string'}
  end
end
