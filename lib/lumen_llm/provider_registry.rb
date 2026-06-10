module LumenLLM
  class ProviderRegistry
    def initialize
      @providers = {}
    end

    def register(name, provider = nil, &block)
      @providers[name.to_s] = block || provider
    end

    def fetch(name)
      provider = @providers[name.to_s]
      raise ConfigurationError, "Unknown LLM provider: #{name}" unless provider

      provider.respond_to?(:call) ? provider.call : provider
    end
  end
end

