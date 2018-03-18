
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "opted/version"

Gem::Specification.new do |spec|
  spec.name          = "opted"
  spec.version       = Opted::VERSION
  spec.authors       = ["Max Holder"]
  spec.email         = ["mxhold@gmail.com"]

  spec.summary       = "Result type in Ruby"
  spec.description   = "Provides Result type (like in Rust) in idiomatic Ruby"
  spec.homepage      = "https://github.com/mxhold/opted"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "yard", "~> 0.9"
end
