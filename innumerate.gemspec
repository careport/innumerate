lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "innumerate/version"

Gem::Specification.new do |spec|
  spec.name = "innumerate"
  spec.version = Innumerate::VERSION
  spec.authors = ["Jon Zeppieri"]
  spec.email = ["zeppieri@gmail.com"]
  spec.summary = <<-DESCRIPTION
    Adds `set_statistics_target` method to ActiveRecord::Migration to manage
    per-column statistics targets for the PostgreSQL query planner
  DESCRIPTION
  spec.homepage = "https://github.com/careport/innumerate"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0")
  spec.test_files = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.6"
  spec.add_development_dependency "rspec", ">= 3.8"
  spec.add_development_dependency "pg", "~> 0.19"

  spec.add_dependency "activerecord", ">= 5.0.0"
  spec.add_dependency "railties", ">= 5.0.0"

  spec.required_ruby_version = "~> 2.1"
end
