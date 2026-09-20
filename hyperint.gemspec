Gem::Specification.new do |spec|
  spec.name = "hyperint"
  spec.version = "0.1.0"
  spec.authors = ["Araki-Tomoya"]
  spec.email = [""]
  spec.required_ruby_version = ">= 3.1"

  spec.summary = "Arbitrary-precision integer library for Ruby"
  spec.description = "A large integer library implemented independently from Ruby Integer."
  spec.homepage = "https://github.com/rimsky-yamatov/hyperint"
  spec.license = "MIT"

  spec.files = Dir["lib/**/*.rb", "README.md", "LICENSE"]
  spec.require_paths = ["lib"]
end