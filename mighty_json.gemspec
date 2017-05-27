# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mighty_json/version"

Gem::Specification.new do |spec|
  spec.name          = "mighty_json"
  spec.version       = MightyJSON::VERSION
  spec.authors       = ["Masataka Kuwabara"]
  spec.email         = ["kuwabara@pocke.me"]

  spec.summary       = %q{A faster implementation of soutaro/strong_json}
  spec.description   = %q{A faster implementation of soutaro/strong_json}
  spec.homepage      = "https://github.com/pocke/mighty_json"
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.3.0'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-power_assert'

  spec.add_development_dependency 'rubocop', '0.48.1'
  spec.add_development_dependency 'meowcop', '1.10.0'
end
