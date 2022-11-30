# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubyvernac/hindi/version'

Gem::Specification.new do |spec|
  spec.name          = "rubyvernac-hindi"
  spec.version       = Rubyvernac::Hindi::VERSION
  spec.authors       = ["rtdp"]
  spec.email         = ["ratnadeepdeshmane@gmail.com"]
  spec.summary       = %q{: Gem that helps writing Ruby programmes in Hindi.}
  spec.description   = %q{ }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
end
