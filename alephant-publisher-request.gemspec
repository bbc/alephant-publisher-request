# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alephant/publisher/request/version'

Gem::Specification.new do |spec|
  spec.name          = "alephant-publisher-request"
  spec.version       = Alephant::Publisher::Request::VERSION
  spec.authors       = ["Integralist"]
  spec.email         = ["mark.mcdx@gmail.com"]
  spec.summary       = "..."
  spec.description   = "..."
  spec.homepage      = "https://github.com/BBC-News/alephant-publisher-request"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "spurious-ruby-awssdk-helper"
  spec.add_development_dependency "rake-rspec"

  spec.add_runtime_dependency 'rack'
  spec.add_runtime_dependency 'rake'
  spec.add_runtime_dependency 'faraday'
  spec.add_runtime_dependency 'aws-sdk', '~> 1.0'
  spec.add_runtime_dependency 'mustache', '>= 0.99.5'
  spec.add_runtime_dependency 'alephant-logger'
  spec.add_runtime_dependency 'alephant-renderer'
end
