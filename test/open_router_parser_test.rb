require "test_helper"

class OpenRouterParserTest < LumenLLMTest
  def test_extracts_json_from_markdown_fenced_content
    raw = {
      "choices" => [
        {
          "message" => {
            "content" => "```json\n{\"de\":\"Speichern\"}\n```"
          }
        }
      ]
    }

    result = LumenLLM::Providers::OpenRouter::Parser.extract(raw, "json")

    assert_equal({ "de" => "Speichern" }, result)
  end

  def test_extracts_plain_text
    raw = {
      "choices" => [
        {
          "message" => {
            "content" => "Plain answer"
          }
        }
      ]
    }

    assert_equal "Plain answer", LumenLLM::Providers::OpenRouter::Parser.extract(raw, "text")
  end

  def test_raises_on_invalid_json_output
    raw = {
      "choices" => [
        {
          "message" => {
            "content" => "not json"
          }
        }
      ]
    }

    error = assert_raises(LumenLLM::ParserError) do
      LumenLLM::Providers::OpenRouter::Parser.extract(raw, "json")
    end

    assert_match(/Invalid JSON output/, error.message)
  end

  def test_raises_when_content_is_missing
    error = assert_raises(LumenLLM::ParserError) do
      LumenLLM::Providers::OpenRouter::Parser.extract({ "choices" => [] }, "text")
    end

    assert_match(/Missing content/, error.message)
  end
end
