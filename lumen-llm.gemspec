require_relative "lib/lumen_llm/version"

Gem::Specification.new do |spec|
  spec.name = "lumen-llm"
  spec.version = LumenLLM::VERSION
  spec.authors = ["Dong Xu"]
  spec.email = ["uxgnod@gmail.com"]

  spec.summary = "A tiny Ruby/Rails-friendly LLM prompt runner for OpenRouter."
  spec.description = "lumen-llm provides YAML prompt templates, single-call OpenRouter chat completion, JSON/text parsing, optional cache stores, and Rails 4+ integration without runtime gem dependencies."
  spec.homepage = "https://github.com/uxgnod/lumen-llm"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.3"

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
    "changelog_uri" => "#{spec.homepage}/blob/main/CHANGELOG.md"
  }

  spec.files = Dir[
    "CHANGELOG.md",
    "LICENSE.txt",
    "README.md",
    "AGENTS.md",
    "lib/**/*.rb",
    "examples/**/*",
    "skills/**/*"
  ]
  spec.bindir = "bin"
  spec.executables = []
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest", ">= 5.10", "< 5.16"
  spec.add_development_dependency "rake", ">= 12.3", "< 14"
end
