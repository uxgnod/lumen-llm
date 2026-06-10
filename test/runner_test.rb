require "test_helper"

class RunnerTest < LumenLLMTest
  class FakeProvider
    attr_reader :calls

    def initialize(*responses)
      @responses = responses
      @calls = []
    end

    def chat(messages, model:)
      @calls << { :messages => messages, :model => model }
      @responses[@calls.length - 1] || @responses.last
    end
  end

  def test_runner_generates_parses_caches_and_tracks_usage
    provider = FakeProvider.new(openrouter_response("{\"answer\":\"Bonjour\"}", "openai/gpt-5-mini"))
    registry = LumenLLM::ProviderRegistry.new
    registry.register("openrouter", provider)
    store = LumenLLM::Stores::MemoryStore.new
    template = template(output_type: "json")

    runner = LumenLLM::Runner.new(
      template: template,
      input: { :text => "Hello" },
      store: store,
      provider_registry: registry
    )

    assert_equal({ "answer" => "Bonjour" }, runner.run)
    assert_equal({ "answer" => "Bonjour" }, runner.run)
    assert_equal 1, provider.calls.length
    assert_equal "openai/gpt-5-mini", provider.calls.first[:model]
    assert_equal "Say Hello", provider.calls.first[:messages][1][:content]
    assert_equal 4, store.stat("prompt_tokens:translator")
    assert_equal 2, store.stat("completion_tokens:translator")
    assert_equal 6, store.stat("usage:translator:total_tokens")
  end

  def test_force_refresh_bypasses_cache
    provider = FakeProvider.new(
      openrouter_response("first", "model"),
      openrouter_response("second", "model")
    )
    registry = LumenLLM::ProviderRegistry.new
    registry.register("openrouter", provider)
    store = LumenLLM::Stores::MemoryStore.new
    template = template(output_type: "text", model: "model")

    runner = LumenLLM::Runner.new(
      template: template,
      input: { :text => "Hello" },
      store: store,
      provider_registry: registry
    )

    assert_equal "first", runner.run
    assert_equal "second", runner.run(force: true)
    assert_equal 2, provider.calls.length
  end

  def test_unknown_provider_raises_configuration_error
    registry = LumenLLM::ProviderRegistry.new
    template = LumenLLM::Template.new(
      key: "custom",
      system_prompt: "System",
      user_prompt: "User",
      model: "model",
      provider: "missing",
      output_type: "text"
    )

    runner = LumenLLM::Runner.new(
      template: template,
      input: {},
      store: LumenLLM::Stores::MemoryStore.new,
      provider_registry: registry
    )

    assert_raises(LumenLLM::ConfigurationError) { runner.run }
  end

  def test_runner_uses_configured_provider_registry
    provider = FakeProvider.new(openrouter_response("configured", "model"))
    registry = LumenLLM::ProviderRegistry.new
    registry.register("openrouter", provider)
    LumenLLM.configuration.provider_registry = registry

    runner = LumenLLM::Runner.new(
      template: template(output_type: "text", model: "model"),
      input: { :text => "Hello" },
      store: LumenLLM::Stores::MemoryStore.new
    )

    assert_equal "configured", runner.run
    assert_equal 1, provider.calls.length
  end

  private

  def template(options = {})
    LumenLLM::Template.new(
      key: "translator",
      system_prompt: "System",
      user_prompt: "Say {{text}}",
      model: options[:model] || "openai/gpt-5-mini",
      provider: "openrouter",
      output_type: options[:output_type] || "json"
    )
  end

  def openrouter_response(content, model)
    {
      "model" => model,
      "choices" => [
        {
          "message" => {
            "content" => content
          }
        }
      ],
      "usage" => {
        "prompt_tokens" => 4,
        "completion_tokens" => 2,
        "total_tokens" => 6
      }
    }
  end
end
