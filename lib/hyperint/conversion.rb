class HyperInt
  def to_s(base = 10)
    raise ArgumentError, "base must be between 2 and 36" unless (2..36).include?(base)
    return "0" if zero?

    value = self
    result = +""

    while !value.zero?
      quotient, remainder = value.divide_small(base)
      result << remainder.to_s(36)
      value = quotient
    end

    result.reverse!
    @sign < 0 ? "-#{result}" : result
  end

  def abs
    copy = HyperInt.new(0)
    copy.instance_variable_set(:@sign, @sign.abs)
    copy.instance_variable_set(:@digits, @digits.dup)
    copy
  end

  def negate
    copy = HyperInt.new(0)
    copy.instance_variable_set(:@sign, -@sign)
    copy.instance_variable_set(:@digits, @digits.dup)
    copy
  end

  def zero?
    @sign == 0
  end

  def positive?
    @sign > 0
  end

  def negative?
    @sign < 0
  end

  def self.zero
    new(0)
  end

  def self.one
    new(1)
  end

  def divide_small(divisor)
    result = []
    remainder = 0

    @digits.reverse_each do |digit|
      current = remainder * BASE + digit
      quotient = current / divisor
      remainder = current % divisor

      result.unshift(quotient)
    end

    result.shift while result.length > 1 && result[0] == 0

    quotient = HyperInt.new(0)
    quotient.instance_variable_set(:@sign, result == [0] ? 0 : 1)
    quotient.instance_variable_set(:@digits, result.reverse)

    [quotient, remainder]
  end
end
