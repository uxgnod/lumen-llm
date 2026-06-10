require "test_helper"

class GemspecTest < LumenLLMTest
  def test_gemspec_keeps_public_compatibility_floor_and_no_runtime_dependencies
    spec = Gem::Specification.load(File.expand_path("../lumen-llm.gemspec", __dir__))

    assert_equal "lumen-llm", spec.name
    assert_equal ">= 2.3", spec.required_ruby_version.to_s
    assert_equal [], spec.runtime_dependencies
    assert_equal ">= 5.10, < 5.16", spec.development_dependencies.find { |dependency| dependency.name == "minitest" }.requirement.to_s
    assert_includes spec.files, "lib/lumen_llm.rb"
    assert_includes spec.files, "skills/lumen-llm-setup/SKILL.md"
  end
end
