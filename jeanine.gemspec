require_relative 'lib/jeanine/version'

Gem::Specification.new do |spec|
  spec.name          = "jeanine"
  spec.version       = Jeanine::VERSION
  spec.authors       = ["Josh Brody"]
  spec.email         = ["git@josh.mn"]

  spec.summary       = "A lightning-fast, batteries-included Ruby web micro-framework."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/joshmn/jeanine"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/joshmn/jeanine"
  spec.metadata["changelog_uri"] = "https://github.com/joshmn/jeanine"

  spec.files = Dir['lib/**/*.rb']

  spec.bindir        = "exe"
  spec.executables   = ["jeanine"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rack'
  spec.add_runtime_dependency 'tilt'
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "pry"
end
