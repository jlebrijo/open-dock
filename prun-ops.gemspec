# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prun-ops/version'

Gem::Specification.new do |spec|
  spec.name          = "prun-ops"
  spec.version       = PrunOps::VERSION
  spec.authors       = ["Juan Lebrijo"]
  spec.email         = ["juan@lebrijo.com"]
  spec.summary       = %q{Encapsulates Operations commands needed for a Rails Application.}
  spec.description   = %q{Encapsulates Operations commands for Rails Applications: Provision, Configure, Deploy, Diagnose, Version Releasing and Backup.}
  spec.homepage      = "http://github.com/jlebrijo/prun-ops"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.executables   = ['ops']

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "capistrano-rails"
  spec.add_runtime_dependency "commander"
  spec.add_runtime_dependency "thin", "1.6.2"
  spec.add_runtime_dependency "droplet_kit"
end
