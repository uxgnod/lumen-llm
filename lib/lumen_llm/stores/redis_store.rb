require "json"
require "date"

module LumenLLM
  module Stores
    class RedisStore
      def initialize(redis)
        @redis = redis
      end

      def cache(key, options = {})
        ttl = options[:ttl] || 3600
        value = @redis.get(key)
        return JSON.parse(value) if value

        result = yield
        @redis.setex(key, ttl, result.to_json)
        result
      end

      def incr_stat(metric, amount = 1)
        @redis.incrby("stats:#{metric}", amount.to_i)
      end

      def stat(key)
        @redis.get("stats:#{key}").to_i
      end

      def all_stats(pattern = "stats:*")
        result = {}
        @redis.keys(pattern).each do |key|
          result[key] = @redis.get(key).to_i
        end
        result
      end

      def track_usage(template_key, model, usage)
        date = Date.today.strftime("%Y-%m-%d")
        [
          "usage:total",
          "usage:#{template_key}",
          "usage:model:#{model}",
          "usage:#{template_key}:model:#{model}",
          "usage:date:#{date}",
          "usage:#{template_key}:date:#{date}"
        ].each do |prefix|
          incr_stat("#{prefix}:prompt_tokens", usage["prompt_tokens"])
          incr_stat("#{prefix}:completion_tokens", usage["completion_tokens"])
          incr_stat("#{prefix}:total_tokens", usage["total_tokens"])
        end
      end
    end
  end
end

