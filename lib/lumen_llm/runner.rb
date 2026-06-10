require "digest/sha1"
require "json"

module LumenLLM
  class Runner
    def initialize(template:, input:, store: nil, provider_registry: nil)
      @template = template
      @input = input
      @store = store || LumenLLM.configuration.store || Stores::NullStore.new
      @provider_registry = provider_registry || LumenLLM.configuration.provider_registry || LumenLLM.provider_registry
    end

    def run(force: false)
      cache_key = "lumen:#{@template.key}:#{Digest::SHA1.hexdigest(@input.to_json)}"

      raw = if force
        log("[LumenLLM::Runner] FORCE REFRESH: #{cache_key}")
        generate
      else
        @store.cache(cache_key, :ttl => LumenLLM.configuration.cache_ttl) { generate }
      end

      Parser.extract(
        provider: @template.provider,
        raw: raw,
        output_type: @template.output_type
      )
    end

    private

    def generate
      payload = @template.render(@input)
      response = @provider_registry.fetch(payload[:provider]).chat(payload[:messages], model: payload[:model])
      track_stats(@template.key, response)
      response
    end

    def track_stats(key, response)
      usage = response["usage"] || {}
      @store.incr_stat("prompt_tokens:#{key}", usage["prompt_tokens"]) if usage["prompt_tokens"]
      @store.incr_stat("completion_tokens:#{key}", usage["completion_tokens"]) if usage["completion_tokens"]
      @store.track_usage(key, response["model"], usage)
    end

    def log(message)
      LumenLLM.configuration.logger.info(message)
    end
  end
end
