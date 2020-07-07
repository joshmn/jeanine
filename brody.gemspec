require_relative 'lib/brody/version'

Gem::Specification.new do |spec|
  spec.name          = "brody"
  spec.version       = Brody::VERSION
  spec.authors       = ["Josh Brody"]
  spec.email         = ["git@josh.mn"]

  spec.summary       = "A framework."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/joshmn/broding"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/joshmn/broding"
  spec.metadata["changelog_uri"] = "https://github.com/joshmn/broding"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir['lib/**/*.rb']

  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rack'
  spec.add_runtime_dependency 'tilt'
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
