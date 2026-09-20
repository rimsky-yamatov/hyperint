class HyperInt
  def equals?(other)
    check_type(other)
    to_i == other.to_i
  end

  def not_equals?(other)
    !equals?(other)
  end

  def greater_than?(other)
    check_type(other)
    to_i > other.to_i
  end

  def greater_than_or_equal?(other)
    check_type(other)
    to_i >= other.to_i
  end

  def less_than?(other)
    check_type(other)
    to_i < other.to_i
  end

  def less_than_or_equal?(other)
    check_type(other)
    to_i <= other.to_i
  end

  private

  def check_type(other)
    raise TypeError, "argument must be HyperInt" unless other.is_a?(HyperInt)
  end
end