# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ovaltine/version'

Gem::Specification.new do |spec|
  spec.name          = "ovaltine"
  spec.version       = Ovaltine::VERSION
  spec.authors       = ["Delisa Mason"]
  spec.email         = ["iskanamagus@gmail.com"]
  spec.required_ruby_version = '>= 1.8.7'
  spec.description   =
  %q{
  Constant generator for identifiers in Cocoa app storyboards
  }
  spec.summary       = %q{Cocoa app constant generator}
  spec.homepage      = "https://github.com/kattrali/ovaltine"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "bacon"
end