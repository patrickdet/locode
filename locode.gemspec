# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'locode/version'

Gem::Specification.new do |spec|
  spec.name          = 'locode'
  spec.version       = Locode::VERSION
  spec.authors       = ['Patrick Detlefsen']
  spec.email         = ['patrick.detlefsen@gmail.com']
  spec.description   = %q{The Locode gem gives you the ability to lookup UN/LOCODE codes.}
  spec.summary       = %q{The Locode gem gives you the ability to lookup UN/LOCODE codes.}
  spec.homepage      = 'https://github.com/patrickdet/locode'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'multi_json', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
end