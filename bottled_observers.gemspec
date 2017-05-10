# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bottled_observers/version'

Gem::Specification.new do |spec|
  spec.name          = 'bottled_observers'
  spec.version       = BottledObservers::VERSION
  spec.authors       = ['John Hayes-Reed']
  spec.email         = ['john.hayes.reed@gmail.com']

  spec.summary       = 'A Rails compatible Observer pattern solution made to '\
                       'make your life easy.'
  spec.description   = 'This Gem provides two interfaces, one to make items '\
                       'observable, and another to easily create classes to '\
                       'observe them.'
  spec.homepage      = 'https://github.com/John-Hayes-Reed/bottled_observers'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15.a'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
