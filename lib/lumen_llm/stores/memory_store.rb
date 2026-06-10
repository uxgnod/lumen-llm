require "date"

module LumenLLM
  module Stores
    class MemoryStore
      def initialize
        @values = {}
        @stats = Hash.new(0)
      end

      def cache(key, _options = {})
        return @values[key] if @values.key?(key)

        @values[key] = yield
      end

      def incr_stat(metric, amount = 1)
        @stats["stats:#{metric}"] += amount.to_i
      end

      def stat(key)
        @stats["stats:#{key}"].to_i
      end

      def all_stats(pattern = "stats:*")
        prefix = pattern.sub(/\*$/, "")
        result = {}
        @stats.each do |key, value|
          result[key] = value if key.index(prefix) == 0
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

