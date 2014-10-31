# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'interest/version'

Gem::Specification.new do |spec|
  spec.name          = "interest"
  spec.version       = Interest::VERSION
  spec.authors       = ["tatat"]
  spec.email         = ["ioiioioloo@gmail.com"]
  spec.summary       = %q{Follow, follow request and block with ActiveRecord.}
  spec.description   = %q{A gem to follow, follow request and block between any ActiveRecord models.}
  spec.homepage      = "https://github.com/conol/interest"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 4.0"
  spec.add_dependency "activerecord", "~> 4.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "sqlite3", "~> 1.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-collection_matchers", "~> 1"
end
