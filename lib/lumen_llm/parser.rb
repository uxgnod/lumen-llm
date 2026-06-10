module LumenLLM
  module Parser
    def self.extract(provider:, raw:, output_type:)
      case provider.to_s
      when "openrouter"
        Providers::OpenRouter::Parser.extract(raw, output_type)
      else
        raise ParserError, "No parser defined for provider: #{provider}"
      end
    end
  end
end

