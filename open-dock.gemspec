# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'open-dock/version'

Gem::Specification.new do |spec|
  spec.name          = "open-dock"
  spec.version       = OpenDock::VERSION
  spec.authors       = ["Juan Lebrijo"]
  spec.email         = ["juan@lebrijo.com"]
  spec.summary       = %q{Encapsulates Provision and Configuration Operations commands needed for complex server clouds.}
  spec.description   = %q{Encapsulates Operations commands for complex server clouds: Provision and Configuration from all possible providers such as DigitalOcean, Google Cloud, Rackspace, Linode,...}
  spec.homepage      = "http://github.com/jlebrijo/open-dock"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.executables   = ['ops']

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "commander"
  spec.add_runtime_dependency "droplet_kit"
end
