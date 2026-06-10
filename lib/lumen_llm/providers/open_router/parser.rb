require "json"

module LumenLLM
  module Providers
    module OpenRouter
      class Parser
        def self.extract(raw, output_type = "text")
          content = raw.dig("choices", 0, "message", "content")
          raise ParserError, "Missing content in response." unless content

          clean = content.gsub(/```json|```/, "").strip

          case output_type.to_s
          when "json"
            begin
              JSON.parse(clean)
            rescue JSON::ParserError
              raise ParserError, "Invalid JSON output:\n#{clean}"
            end
          else
            clean
          end
        end
      end
    end
  end
end

