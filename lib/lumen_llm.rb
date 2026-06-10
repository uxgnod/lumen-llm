require "lumen_llm/version"
require "lumen_llm/errors"
require "lumen_llm/configuration"
require "lumen_llm/template"
require "lumen_llm/template_loader"
require "lumen_llm/provider_registry"
require "lumen_llm/stores/null_store"
require "lumen_llm/stores/memory_store"
require "lumen_llm/stores/redis_store"
require "lumen_llm/providers/open_router/client"
require "lumen_llm/providers/open_router/parser"
require "lumen_llm/parser"
require "lumen_llm/runner"

module LumenLLM
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
      configuration
    end

    def reset_configuration!
      @configuration = Configuration.new
      @provider_registry = nil
    end

    def provider_registry
      @provider_registry ||= default_provider_registry
    end

    def run(template_key, input: {}, force: false, store: nil, provider_registry: nil)
      template = TemplateLoader.load(template_key)
      Runner.new(
        template: template,
        input: input,
        store: store,
        provider_registry: provider_registry
      ).run(force: force)
    end

    private

    def default_provider_registry
      registry = ProviderRegistry.new
      registry.register("openrouter") { Providers::OpenRouter::Client.new }
      registry
    end
  end
end

Lumen = LumenLLM unless defined?(::Lumen)

require "lumen_llm/railtie" if defined?(Rails)
