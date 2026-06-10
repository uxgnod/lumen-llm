require "test_helper"

class ConfigurationTest < LumenLLMTest
  def test_configure_sets_runtime_options
    store = LumenLLM::Stores::MemoryStore.new

    LumenLLM.configure do |config|
      config.template_path = "/tmp/lumen_templates"
      config.openrouter_api_key = "secret"
      config.openrouter_referer = "https://example.test"
      config.openrouter_title = "Example"
      config.store = store
      config.cache_ttl = 120
      config.http_open_timeout = 3
      config.http_read_timeout = 9
    end

    config = LumenLLM.configuration
    assert_equal "/tmp/lumen_templates", config.template_path
    assert_equal "secret", config.openrouter_api_key
    assert_equal "https://example.test", config.openrouter_referer
    assert_equal "Example", config.openrouter_title
    assert_same store, config.store
    assert_equal 120, config.cache_ttl
    assert_equal 3, config.http_open_timeout
    assert_equal 9, config.http_read_timeout
  end

  def test_reset_configuration_rebuilds_provider_registry
    first = LumenLLM.provider_registry

    LumenLLM.reset_configuration!

    refute_same first, LumenLLM.provider_registry
  end

  def test_configuration_reads_openrouter_environment
    with_env("OPENROUTER_API_KEY" => "env-key", "OPENROUTER_REFERER" => "https://env.test", "OPENROUTER_TITLE" => "EnvTitle") do
      LumenLLM.reset_configuration!

      config = LumenLLM.configuration
      assert_equal "env-key", config.openrouter_api_key
      assert_equal "https://env.test", config.openrouter_referer
      assert_equal "EnvTitle", config.openrouter_title
    end
  end
end
