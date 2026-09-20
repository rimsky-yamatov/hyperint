require_relative "hyperint/arithmetic"
require_relative "hyperint/comparison"
require_relative "hyperint/conversion"

class HyperInt
  attr_reader :sign, :digits

  def initialize(value, base = 10)
    raise TypeError, "value must be an Integer or String" unless value.is_a?(Integer) || value.is_a?(String)
    raise ArgumentError, "base must be between 2 and 36" unless (2..36).include?(base)

    if value.is_a?(Integer)
      @sign = value <=> 0
      value = value.abs.to_s
    else
      value = value.strip
      @sign = value.start_with?("-") ? -1 : 1
      value = value.delete_prefix("-").delete_prefix("+")
      raise ArgumentError, "invalid integer" unless value.match?(/\A[0-9a-zA-Z]+\z/)
    end

    @sign = 0 if value.to_i(base).zero?
    @digits = value.to_i(base).to_s(10)
  end

  def self.from_integer(value)
    new(value)
  end

  def to_i
    value = @digits.to_i
    @sign < 0 ? -value : value
  end
end