# HyperInt

HyperInt is an arbitrary-precision integer library for Ruby.

It provides large integer arithmetic using its own internal representation instead of relying on Ruby's `Integer` for internal calculations.

## Features

- Arbitrary-precision integers
- Addition
- Subtraction
- Multiplication
- Division
- Modulo
- Exponentiation
- Comparison
- Base conversion
- Integer conversion
- Positive, negative, and zero checks
- Immutable arithmetic operations

## Installation

```bash
gem install hyperint
```

## Usage

```ruby
require "hyperint"

a = HyperInt.new("123456789012345678901234567890")
b = HyperInt.new("98765432109876543210")

puts a.add(b).to_s
puts a.sub(b).to_s
puts a.mul(b).to_s
puts a.div(b).to_s
puts a.mod(b).to_s
```

## Exponentiation

```ruby
a = HyperInt.new("2")
b = HyperInt.new("100")

puts a.pow(b).to_s
```

Output:

```text
1267650600228229401496703205376
```

## Conversion

```ruby
value = HyperInt.new("12345678901234567890")

puts value.to_s
puts value.to_s(16)
puts value.to_i
```

## Utility Methods

```ruby
value = HyperInt.new("-12345")

puts value.abs.to_s
puts value.negate.to_s
puts value.zero?
puts value.positive?
puts value.negative?
```

## Constructors

```ruby
HyperInt.zero
HyperInt.one
HyperInt.from_integer(12345)
```

## Comparison

```ruby
a = HyperInt.new("100")
b = HyperInt.new("50")

puts a.equals?(b)
puts a.not_equals?(b)
puts a.greater_than?(b)
puts a.greater_than_or_equal?(b)
puts a.less_than?(b)
puts a.less_than_or_equal?(b)
```

## Requirements

- Ruby >= 3.1

## License

HyperInt is released under the MIT License.

Copyright (c) 2026 Araki-Tomoya