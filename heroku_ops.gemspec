# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heroku_ops/version'

Gem::Specification.new do |spec|
  spec.name          = "heroku_ops"
  spec.version       = HerokuOps::VERSION
  spec.authors       = ["nrowegt"]
  spec.email         = ["rowe.nathaniel@gmail.com"]

  spec.summary       = "Helpful Heroku Ops Rake Tasks"
  spec.description   = "Tasks to setup pipelines for your app with the typical free tier addons and run deploys and db restores"
  spec.homepage      = "https://github.com/nrowegt/heroku_ops"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "heroku_rake_deploy", "~> 0.0.2"
  spec.add_runtime_dependency "heroku_rake_deploy", "~> 0.0.2"  
end
