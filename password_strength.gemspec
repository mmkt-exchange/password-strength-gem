# coding: utf-8

require File.expand_path('../lib/password_strength/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'password_strength'
  spec.version       = PasswordStrength::VERSION
  spec.authors       = ['Adrián Mugnolo']
  spec.email         = ['adrian@mugnolo.com']

  spec.summary       = 'A password strength calculator library.'
  spec.homepage      = 'http://github.com/mmkt-exchange/password_strength'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^test/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest'
end
