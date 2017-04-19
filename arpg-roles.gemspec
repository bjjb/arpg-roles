# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arpg/roles/version'

Gem::Specification.new do |spec|
  spec.name          = "arpg-roles"
  spec.version       = ARPG::Roles::VERSION
  spec.authors       = ["JJ Buckley"]
  spec.email         = ["jj@bjjb.org"]

  spec.summary       = %q{ActiveRecord PostgreSQL roles helper}
  spec.description   = <<-DESC
Use a Postgres array column to manage a model's roles
  DESC
  spec.homepage      = "http://github.com/bjjb/arpg-roles"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord', '~> 4.2'
  spec.add_dependency 'activesupport', '~> 4.2'
  spec.add_dependency 'pg', '~> 0.18'
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
