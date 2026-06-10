require "test_helper"

class OpenRouterClientTest < LumenLLMTest
  Response = Struct.new(:code, :body)

  class FakeTransport
    attr_reader :requests

    def initialize(response)
      @response = response
      @requests = []
    end

    def request(uri, headers, body, open_timeout, read_timeout)
      @requests << {
        :uri => uri,
        :headers => headers,
        :body => body,
        :open_timeout => open_timeout,
        :read_timeout => read_timeout
      }
      @response
    end
  end

  def test_chat_posts_json_to_openrouter_and_parses_response
    response = Response.new(
      "200",
      {
        "choices" => [
          { "message" => { "content" => "ok" } }
        ],
        "usage" => { "total_tokens" => 3 }
      }.to_json
    )
    transport = FakeTransport.new(response)

    client = LumenLLM::Providers::OpenRouter::Client.new(
      api_key: "token",
      referer: "https://app.test",
      title: "App",
      transport: transport,
      open_timeout: 2,
      read_timeout: 8
    )

    result = client.chat([{ :role => "user", :content => "Hello" }], model: "openai/gpt-5-mini")

    assert_equal "ok", result["choices"][0]["message"]["content"]
    request = transport.requests.first
    assert_equal "/api/v1/chat/completions", request[:uri].request_uri
    assert_equal "Bearer token", request[:headers]["Authorization"]
    assert_equal "https://app.test", request[:headers]["HTTP-Referer"]
    assert_equal "App", request[:headers]["X-Title"]
    assert_equal 2, request[:open_timeout]
    assert_equal 8, request[:read_timeout]
    assert_equal "openai/gpt-5-mini", JSON.parse(request[:body])["model"]
  end

  def test_chat_requires_api_key
    transport = FakeTransport.new(Response.new("200", "{}"))
    client = LumenLLM::Providers::OpenRouter::Client.new(api_key: " ", transport: transport)

    error = assert_raises(LumenLLM::ConfigurationError) do
      client.chat([], model: "model")
    end

    assert_match(/API key/, error.message)
    assert_equal 0, transport.requests.length
  end

  def test_chat_raises_provider_error_on_non_success
    transport = FakeTransport.new(Response.new("500", "server error"))
    client = LumenLLM::Providers::OpenRouter::Client.new(api_key: "token", transport: transport)

    error = assert_raises(LumenLLM::ProviderError) do
      client.chat([], model: "model")
    end

    assert_match(/500 - server error/, error.message)
  end
end
