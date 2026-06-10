require "logger"

module LumenLLM
  class Configuration
    attr_accessor :template_path,
                  :openrouter_api_key,
                  :openrouter_referer,
                  :openrouter_title,
                  :store,
                  :provider_registry,
                  :cache_ttl,
                  :http_open_timeout,
                  :http_read_timeout

    attr_writer :logger

    def initialize
      @template_path = nil
      @logger = nil
      @openrouter_api_key = ENV["OPENROUTER_API_KEY"]
      @openrouter_referer = ENV["OPENROUTER_REFERER"] || "https://example.com"
      @openrouter_title = ENV["OPENROUTER_TITLE"] || "lumen-llm"
      @store = nil
      @provider_registry = nil
      @cache_ttl = 3600
      @http_open_timeout = 10
      @http_read_timeout = 60
    end

    def logger
      @logger ||= Logger.new($stderr)
    end

    def logger_configured?
      !@logger.nil?
    end
  end
end

