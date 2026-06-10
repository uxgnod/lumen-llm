module LumenLLM
  class Error < StandardError; end
  class ConfigurationError < Error; end
  class TemplateNotFoundError < Error; end
  class ParserError < Error; end
  class ProviderError < Error; end
end

