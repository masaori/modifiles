# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'modifiles/version'

Gem::Specification.new do |gem|
  gem.name          = "modifiles"
  gem.version       = Modifiles::VERSION
  gem.authors       = ["masaori"]
  gem.email         = ["masaori@pankaku.com"]
  gem.description   = "Check and detect modified files using `git diff`"
  gem.summary       = "Check and detect modified files using `git diff`"
  gem.homepage      = "https://github.com/masaori/modifiles"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
