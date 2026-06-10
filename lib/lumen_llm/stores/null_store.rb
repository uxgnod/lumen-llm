module LumenLLM
  module Stores
    class NullStore
      def cache(_key, _options = {})
        yield
      end

      def incr_stat(_metric, _amount = 1)
      end

      def stat(_key)
        0
      end

      def all_stats(_pattern = "stats:*")
        {}
      end

      def track_usage(_template_key, _model, _usage)
      end
    end
  end
end

