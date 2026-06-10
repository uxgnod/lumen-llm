require "test_helper"

class NamespaceTest < LumenLLMTest
  def test_lumen_llm_is_the_canonical_namespace
    assert_equal "0.1.0", LumenLLM::VERSION
    assert_respond_to LumenLLM, :run
  end

  def test_lumen_alias_is_available_for_internal_lumen_migrations
    assert_same LumenLLM, Lumen
    assert_same LumenLLM::Template, Lumen::Template
  end

  def test_require_lumen_loads_compatibility_entrypoint
    assert require("lumen")
    assert_same LumenLLM, Lumen
  end
end
