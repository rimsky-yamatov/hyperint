class HyperInt
  def to_s(base = 10)
    raise ArgumentError, "base must be between 2 and 36" unless (2..36).include?(base)

    value = to_i
    value.to_s(base)
  end

  def abs
    HyperInt.new(to_i.abs)
  end

  def negate
    HyperInt.new(-to_i)
  end

  def zero?
    to_i.zero?
  end

  def positive?
    to_i.positive?
  end

  def negative?
    to_i.negative?
  end

  def self.zero
    new(0)
  end

  def self.one
    new(1)
  end
end