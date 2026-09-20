require "minitest/autorun"
require_relative "../lib/hyperint"

class TestHyperInt < Minitest::Test
  def test_initialize
    assert_equal 123456789, HyperInt.new("123456789").to_i
    assert_equal(-123456789, HyperInt.new("-123456789").to_i)
    assert_equal 0, HyperInt.new("0").to_i
  end

  def test_add
    a = HyperInt.new("12345678901234567890")
    b = HyperInt.new("98765432109876543210")

    assert_equal 111111111011111111100, a.add(b).to_i
  end

  def test_sub
    a = HyperInt.new("98765432109876543210")
    b = HyperInt.new("12345678901234567890")

    assert_equal 86419753208641975320, a.sub(b).to_i
  end

  def test_mul
    a = HyperInt.new("123456789")
    b = HyperInt.new("987654321")

    assert_equal 121932631112635269, a.mul(b).to_i
  end

  def test_div
    a = HyperInt.new("100000000000000000000")
    b = HyperInt.new("123456789")

    assert_equal 810000007371, a.div(b).to_i
  end

  def test_mod
    a = HyperInt.new("100000000000000000000")
    b = HyperInt.new("123456789")

    assert_equal 8281, a.mod(b).to_i
  end

  def test_pow
    a = HyperInt.new("2")
    b = HyperInt.new("100")

    assert_equal 1267650600228229401496703205376, a.pow(b).to_i
  end

  def test_equals
    a = HyperInt.new("123456789")
    b = HyperInt.new("123456789")
    c = HyperInt.new("987654321")

    assert a.equals?(b)
    refute a.equals?(c)
  end

  def test_not_equals
    a = HyperInt.new("123")
    b = HyperInt.new("456")

    assert a.not_equals?(b)
    refute a.not_equals?(HyperInt.new("123"))
  end

  def test_greater_than
    a = HyperInt.new("200")
    b = HyperInt.new("100")

    assert a.greater_than?(b)
    refute b.greater_than?(a)
  end

  def test_greater_than_or_equal
    a = HyperInt.new("200")
    b = HyperInt.new("200")
    c = HyperInt.new("100")

    assert a.greater_than_or_equal?(b)
    assert a.greater_than_or_equal?(c)
    refute c.greater_than_or_equal?(a)
  end

  def test_less_than
    a = HyperInt.new("100")
    b = HyperInt.new("200")

    assert a.less_than?(b)
    refute b.less_than?(a)
  end

  def test_less_than_or_equal
    a = HyperInt.new("100")
    b = HyperInt.new("100")
    c = HyperInt.new("200")

    assert a.less_than_or_equal?(b)
    assert a.less_than_or_equal?(c)
    refute c.less_than_or_equal?(a)
  end

  def test_abs
    assert_equal 123456789, HyperInt.new("-123456789").abs.to_i
    assert_equal 123456789, HyperInt.new("123456789").abs.to_i
  end

  def test_negate
    assert_equal(-123456789, HyperInt.new("123456789").negate.to_i)
    assert_equal 123456789, HyperInt.new("-123456789").negate.to_i
  end

  def test_zero
    assert HyperInt.zero.zero?
    refute HyperInt.one.zero?
  end

  def test_positive
    assert HyperInt.new("1").positive?
    refute HyperInt.new("0").positive?
    refute HyperInt.new("-1").positive?
  end

  def test_negative
    assert HyperInt.new("-1").negative?
    refute HyperInt.new("0").negative?
    refute HyperInt.new("1").negative?
  end

  def test_to_s
    a = HyperInt.new("123456789")

    assert_equal "123456789", a.to_s
    assert_equal "75bcd15", a.to_s(16)
    assert_equal "111010110111100110100010101", a.to_s(2)
  end

  def test_base
    a = HyperInt.new("FFFFFFFF", 16)

    assert_equal 4294967295, a.to_i
    assert_equal "FFFFFFFF".downcase, a.to_s(16)
  end

  def test_integer_conversion
    a = HyperInt.new("123456789")

    assert_equal 123456789, a.to_i
    assert_instance_of Integer, a.to_i
  end

  def test_operations_require_hyper_int
    a = HyperInt.new("100")

    assert_raises(TypeError) { a.add(1) }
    assert_raises(TypeError) { a.sub(1) }
    assert_raises(TypeError) { a.mul(1) }
    assert_raises(TypeError) { a.div(1) }
    assert_raises(TypeError) { a.mod(1) }
    assert_raises(TypeError) { a.pow(2) }
  end

  def test_division_by_zero
    a = HyperInt.new("100")
    zero = HyperInt.zero

    assert_raises(ZeroDivisionError) { a.div(zero) }
    assert_raises(ZeroDivisionError) { a.mod(zero) }
  end

  def test_negative_exponent
    a = HyperInt.new("2")
    exponent = HyperInt.new("-1")

    assert_raises(ArgumentError) { a.pow(exponent) }
  end

  def test_immutability
    a = HyperInt.new("100")
    b = HyperInt.new("50")

    result = a.add(b)

    assert_equal 100, a.to_i
    assert_equal 150, result.to_i
    refute_same a, result
  end

  def test_method_chaining
    a = HyperInt.new("100")
    b = HyperInt.new("20")
    c = HyperInt.new("5")

    result = a.add(b).mul(c).sub(b).div(c)

    assert_equal 100, result.to_i
  end
end