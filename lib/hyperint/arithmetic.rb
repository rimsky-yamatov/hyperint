class HyperInt
  def add(other)
    check_type(other)

    if zero?
      return other.abs
    end

    if other.zero?
      return abs
    end

    if @sign == other.sign
      result = add_magnitudes(@digits, other.digits)
      return build_from_digits(@sign, result)
    end

    comparison = compare_magnitudes(@digits, other.digits)

    if comparison == 0
      return HyperInt.zero
    end

    if comparison > 0
      result = subtract_magnitudes(@digits, other.digits)
      build_from_digits(@sign, result)
    else
      result = subtract_magnitudes(other.digits, @digits)
      build_from_digits(other.sign, result)
    end
  end

  def sub(other)
    check_type(other)
    add(other.negate)
  end

  def mul(other)
    check_type(other)

    return HyperInt.zero if zero? || other.zero?

    result = Array.new(@digits.length + other.digits.length, 0)

    @digits.each_with_index do |a, i|
      carry = 0

      other.digits.each_with_index do |b, j|
        index = i + j
        value = result[index] + a * b + carry

        result[index] = value % BASE
        carry = value / BASE
      end

      index = i + other.digits.length

      while carry > 0
        value = result[index] + carry
        result[index] = value % BASE
        carry = value / BASE
        index += 1
        result << 0 if index == result.length && carry > 0
      end
    end

    sign = @sign == other.sign ? 1 : -1
    build_from_digits(sign, result)
  end

  def div(other)
    check_type(other)
    raise ZeroDivisionError, "divided by 0" if other.zero?

    HyperInt.new(to_i / other.to_i)
  end

  def mod(other)
    check_type(other)
    raise ZeroDivisionError, "divided by 0" if other.zero?

    HyperInt.new(to_i % other.to_i)
  end

  def pow(other)
    check_type(other)
    raise ArgumentError, "negative exponent" if other.negative?

    HyperInt.new(to_i.pow(other.to_i))
  end

  private

  def add_magnitudes(a, b)
    result = []
    carry = 0
    length = [a.length, b.length].max

    length.times do |i|
      sum = (a[i] || 0) + (b[i] || 0) + carry

      if sum >= BASE
        sum -= BASE
        carry = 1
      else
        carry = 0
      end

      result << sum
    end

    result << carry if carry > 0
    result
  end

  def subtract_magnitudes(a, b)
    result = []
    borrow = 0

    a.length.times do |i|
      difference = a[i] - (b[i] || 0) - borrow

      if difference < 0
        difference += BASE
        borrow = 1
      else
        borrow = 0
      end

      result << difference
    end

    result.pop while result.length > 1 && result[-1] == 0
    result
  end

  def compare_magnitudes(a, b)
    return 1 if a.length > b.length
    return -1 if a.length < b.length

    (a.length - 1).downto(0) do |i|
      return 1 if a[i] > b[i]
      return -1 if a[i] < b[i]
    end

    0
  end

  def build_from_digits(sign, digits)
    result = HyperInt.new(0)
    result.instance_variable_set(:@sign, sign)
    result.instance_variable_set(:@digits, digits)
    result.send(:normalize)
    result
  end
end