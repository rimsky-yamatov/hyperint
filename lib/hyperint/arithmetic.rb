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