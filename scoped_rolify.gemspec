lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scoped_rolify/version'

Gem::Specification.new do |spec|
  spec.name          = 'scoped_rolify'
  spec.version       = ScopedRolify::VERSION
  spec.authors       = ['Joel AZEMAR']
  spec.email         = ['joel.azemar@gmail.com']
  spec.summary       = %q{This is a monkey patch of rolify}
  spec.description   = %q{This is a monkey patch of rolify, and add new methods}
  spec.homepage      = 'https://github.com/joel/scoped_rolify'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rolify', '~> 5.3.0'

  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'rake', '~> 10.1'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'rspec-rails', '~> 2.14'

  spec.required_ruby_version = '>= 2.2.2'
end
