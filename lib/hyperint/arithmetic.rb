class HyperInt
  def add(other)
    check_type(other)
    HyperInt.new(to_i + other.to_i)
  end

  def sub(other)
    check_type(other)
    HyperInt.new(to_i - other.to_i)
  end

  def mul(other)
    check_type(other)
    HyperInt.new(to_i * other.to_i)
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

  def check_type(other)
    raise TypeError, "argument must be HyperInt" unless other.is_a?(HyperInt)
  end
end