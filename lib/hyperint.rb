require_relative "hyperint/arithmetic"
require_relative "hyperint/comparison"
require_relative "hyperint/conversion"

class HyperInt
  BASE = 1_000_000_000
  BASE_DIGITS = 9

  attr_reader :sign, :digits

  def initialize(value, base = 10)
    raise TypeError, "value must be an Integer or String" unless value.is_a?(Integer) || value.is_a?(String)
    raise ArgumentError, "base must be between 2 and 36" unless (2..36).include?(base)

    if value.is_a?(Integer)
      initialize_from_integer(value)
    else
      initialize_from_string(value, base)
    end
  end

  def self.from_integer(value)
    new(value)
  end

  def to_i
    value = 0

    @digits.reverse_each do |digit|
      value = value * BASE + digit
    end

    @sign < 0 ? -value : value
  end

  private

  def initialize_from_integer(value)
    @sign = value <=> 0
    value = value.abs
    @digits = []

    while value > 0
      @digits << value % BASE
      value /= BASE
    end
  end

  def initialize_from_string(value, base)
    value = value.strip

    negative = value.start_with?("-")
    value = value.delete_prefix("-").delete_prefix("+")

    raise ArgumentError, "invalid integer" unless value.match?(/\A[0-9a-zA-Z]+\z/)

    @sign = negative ? -1 : 1
    @digits = convert_string_to_digits(value, base)
    normalize
  end

  def convert_string_to_digits(value, base)
    result = [0]

    value.each_char do |char|
      digit = char.to_i(base)

      raise ArgumentError, "invalid digit" if digit >= base

      carry = digit

      result.each_index do |i|
        current = result[i] * base + carry
        result[i] = current % BASE
        carry = current / BASE
      end

      result << carry if carry > 0
    end

    result
  end

  def normalize
    @digits.pop while @digits.length > 1 && @digits[-1] == 0

    if @digits.length == 1 && @digits[0] == 0
      @sign = 0
    end
  end

  def check_type(other)
    raise TypeError, "argument must be HyperInt" unless other.is_a?(HyperInt)
  end

  private :check_type
end