# -*- encoding: utf-8 -*-

require File.expand_path('../lib/dicel/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "dicel"
  gem.version       = Dicel::VERSION
  gem.summary       = %q{Dicel is a DSL for rolling dice in Ruby.}
  gem.description   = %q{Usage: `(1.d3 + 1).roll # => (number between 2 and 4)}
  gem.license       = "MIT"
  gem.authors       = ["Mark Rushakoff"]
  gem.homepage      = "https://github.com/mark-rushakoff/dicel#readme"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler", "~> 1.0"
end
