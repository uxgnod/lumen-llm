require "test_helper"

class GemspecTest < LumenLLMTest
  def test_gemspec_keeps_public_compatibility_floor_and_no_runtime_dependencies
    spec = Gem::Specification.load(File.expand_path("../lumen-llm.gemspec", __dir__))

    assert_equal "lumen-llm", spec.name
    assert_equal ">= 2.3", spec.required_ruby_version.to_s
    assert_equal [], spec.runtime_dependencies
    assert_equal ">= 5.10, < 5.16", spec.development_dependencies.find { |dependency| dependency.name == "minitest" }.requirement.to_s
    assert_equal ">= 0.1, < 0.2", spec.development_dependencies.find { |dependency| dependency.name == "mutex_m" }.requirement.to_s
    assert_equal "https://github.com/uxgnod/lumen-llm", spec.metadata["source_code_uri"]
    assert_equal "https://github.com/uxgnod/lumen-llm/issues", spec.metadata["bug_tracker_uri"]
    assert_equal "https://rubygems.org", spec.metadata["allowed_push_host"]
    assert_equal "true", spec.metadata["rubygems_mfa_required"]
    assert_includes spec.files, "lib/lumen_llm.rb"
    assert_includes spec.files, "CONTRIBUTING.md"
    assert_includes spec.files, "SECURITY.md"
    assert_includes spec.files, "skills/lumen-llm-setup/SKILL.md"
  end
end
