# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'schai/version'

Gem::Specification.new do |spec|
  spec.name          = "schai"
  spec.version       = Schai::VERSION
  spec.authors       = ["gin0606"]
  spec.email         = ["kkgn06@gmail.com"]

  spec.summary       = "Generate JSON Schema from simple yaml."
  spec.description   = "Generate JSON Schema from simple yaml."
  spec.homepage      = "https://github.com/gin0606/schai"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
