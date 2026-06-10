require "test_helper"

class TemplateTest < LumenLLMTest
  def test_render_interpolates_system_and_user_messages
    template = LumenLLM::Template.new(
      key: "translator",
      system_prompt: "You translate from {{source_language}}.",
      user_prompt: "Translate {{text}} into {{target_language}}.",
      model: "openai/gpt-5-mini",
      provider: "openrouter",
      output_type: "json"
    )

    payload = template.render(
      :source_language => "English",
      "target_language" => "French",
      :text => "Save changes"
    )

    assert_equal "openrouter", payload[:provider]
    assert_equal "openai/gpt-5-mini", payload[:model]
    assert_equal "system", payload[:messages][0][:role]
    assert_equal "You translate from English.", payload[:messages][0][:content]
    assert_equal "Translate Save changes into French.", payload[:messages][1][:content]
  end

  def test_unprovided_variables_are_left_in_place
    template = LumenLLM::Template.new(
      key: "example",
      system_prompt: "{{role}}",
      user_prompt: "Hello {{name}}",
      model: "model"
    )

    payload = template.render(:role => "assistant")

    assert_equal "Hello {{name}}", payload[:messages][1][:content]
  end
end
