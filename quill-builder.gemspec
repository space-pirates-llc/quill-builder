# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "quill/builder/version"

Gem::Specification.new do |spec|
  spec.name          = "quill-builder"
  spec.version       = Quill::Builder::VERSION
  spec.authors       = ["Code Ahss"]
  spec.email         = ["aycabta@gmail.com"]

  spec.summary       = %q{QuillBuilder is converter from Quill.js output to HTML and so on.}
  spec.description   = %q{QuillBuilder is converter from Quill.js output to HTML and so on.}
  spec.homepage      = "https://github.com/space-pirates-llc/quill-builder"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^test/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit", "~> 3.2"
end
