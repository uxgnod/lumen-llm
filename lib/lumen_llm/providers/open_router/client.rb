require "json"
require "net/http"
require "uri"

module LumenLLM
  module Providers
    module OpenRouter
      class Client
        ENDPOINT = "https://openrouter.ai/api/v1/chat/completions"

        def initialize(api_key: nil, referer: nil, title: nil, transport: nil, open_timeout: nil, read_timeout: nil)
          config = LumenLLM.configuration
          @api_key = api_key || config.openrouter_api_key || ENV["OPENROUTER_API_KEY"]
          @referer = referer || config.openrouter_referer
          @title = title || config.openrouter_title
          @transport = transport || NetHTTPTransport.new
          @open_timeout = open_timeout || config.http_open_timeout
          @read_timeout = read_timeout || config.http_read_timeout
        end

        def chat(messages, model:)
          raise ConfigurationError, "OpenRouter API key is not configured" if blank?(@api_key)

          body = {
            :model => model,
            :messages => messages
          }

          response = @transport.request(
            URI.parse(ENDPOINT),
            headers,
            body.to_json,
            @open_timeout,
            @read_timeout
          )

          unless success?(response)
            raise ProviderError, "OpenRouter API Error: #{response.code} - #{response.body}"
          end

          JSON.parse(response.body)
        end

        private

        def headers
          {
            "Authorization" => "Bearer #{@api_key}",
            "Content-Type" => "application/json",
            "HTTP-Referer" => @referer,
            "X-Title" => @title
          }
        end

        def success?(response)
          response.code.to_i >= 200 && response.code.to_i < 300
        end

        def blank?(value)
          value.nil? || value.to_s.strip == ""
        end
      end

      class NetHTTPTransport
        def request(uri, headers, body, open_timeout, read_timeout)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = uri.scheme == "https"
          http.open_timeout = open_timeout
          http.read_timeout = read_timeout

          request = Net::HTTP::Post.new(uri.request_uri, headers)
          request.body = body
          http.request(request)
        end
      end
    end
  end
end

