# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'assistor/version'

Gem::Specification.new do |spec|
  spec.name          = 'assistor'
  spec.version       = Assistor::VERSION
  spec.authors       = ['Tomasz Kowalewski']
  spec.email         = ['me@tkowalewski.pl']
  spec.summary       = 'Simple background processing framework for Ruby'
  spec.description   = 'Simple background processing framework for Ruby'
  spec.homepage      = 'https://github.com/tkowalewski/assistor'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.2'
  spec.files         = Dir['CHANGELOG.md', 'CODE_OF_CONDUCT.md', 'LICENSE.txt', 'README.md', 'lib/**/*']
  spec.require_paths = ['lib']
  spec.add_dependency 'logger'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
