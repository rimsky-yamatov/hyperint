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

    quotient, = divide_magnitudes(@digits, other.digits)

    if quotient == [0]
      return HyperInt.zero
    end

    sign = @sign == other.sign ? 1 : -1
    build_from_digits(sign, quotient)
  end

  def mod(other)
    check_type(other)
    raise ZeroDivisionError, "divided by 0" if other.zero?

    _, remainder = divide_magnitudes(@digits, other.digits)

    if remainder == [0]
      return HyperInt.zero
    end

    build_from_digits(@sign, remainder)
  end

  def pow(other)
    check_type(other)
    raise ArgumentError, "negative exponent" if other.negative?

    result = HyperInt.one
    base = self.abs
    exponent = other.abs

    while !exponent.zero?
      if exponent.mod(HyperInt.new(2)).equals?(HyperInt.one)
        result = result.mul(base)
      end

      exponent = exponent.div(HyperInt.new(2))
      base = base.mul(base)
    end

    @sign < 0 && other.mod(HyperInt.new(2)).equals?(HyperInt.one) ? result.negate : result
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

  def divide_magnitudes(dividend, divisor)
    return [[0], [0]] if compare_magnitudes(dividend, divisor) < 0

    quotient = Array.new(dividend.length, 0)
    remainder = [0]

    (dividend.length - 1).downto(0) do |i|
      remainder.unshift(dividend[i])
      normalize_digits(remainder)

      low = 0
      high = BASE - 1

      while low <= high
        middle = (low + high) / 2
        product = multiply_magnitude_by_small(divisor, middle)
        comparison = compare_magnitudes(product, remainder)

        if comparison <= 0
          low = middle + 1
        else
          high = middle - 1
        end
      end

      digit = high

      if digit > 0
        product = multiply_magnitude_by_small(divisor, digit)
        remainder = subtract_magnitudes(remainder, product)
      end

      quotient[i] = digit
    end

    normalize_digits(quotient)
    normalize_digits(remainder)

    [quotient, remainder]
  end

  def multiply_magnitude_by_small(digits, multiplier)
    return [0] if multiplier == 0

    result = []
    carry = 0

    digits.each do |digit|
      value = digit * multiplier + carry
      result << value % BASE
      carry = value / BASE
    end

    result << carry if carry > 0
    result
  end

  def normalize_digits(digits)
    digits.pop while digits.length > 1 && digits[-1] == 0

    digits << 0 if digits.empty?

    digits
  end

  def build_from_digits(sign, digits)
    result = HyperInt.new(0)
    result.instance_variable_set(:@sign, sign)
    result.instance_variable_set(:@digits, digits)
    result.send(:normalize)
    result
  end
end