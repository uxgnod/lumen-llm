require "test_helper"

class TemplateLoaderTest < LumenLLMTest
  def test_loads_yaml_template
    Dir.mktmpdir do |dir|
      write_file(
        File.join(dir, "translator.yml"),
        <<-YAML
key: translator
model: openai/gpt-5-mini
provider: openrouter
output_type: json
system_prompt: Translate carefully.
user_prompt: Translate {{text}}.
        YAML
      )

      template = LumenLLM::TemplateLoader.load("translator", path: dir)

      assert_equal "translator", template.key
      assert_equal "openai/gpt-5-mini", template.model
      assert_equal "openrouter", template.provider
      assert_equal "json", template.output_type
      assert_equal "Translate carefully.", template.system_prompt
      assert_equal "Translate {{text}}.", template.user_prompt
    end
  end

  def test_uses_configured_template_path
    Dir.mktmpdir do |dir|
      write_file(
        File.join(dir, "plain.yml"),
        <<-YAML
model: model
system_prompt: System
user_prompt: User
        YAML
      )

      LumenLLM.configuration.template_path = dir

      assert_equal "plain", LumenLLM::TemplateLoader.load("plain").key
    end
  end

  def test_raises_when_template_path_is_not_configured
    error = assert_raises(LumenLLM::ConfigurationError) do
      LumenLLM::TemplateLoader.load("missing")
    end

    assert_match(/template_path/, error.message)
  end

  def test_raises_when_template_file_is_missing
    Dir.mktmpdir do |dir|
      error = assert_raises(LumenLLM::TemplateNotFoundError) do
        LumenLLM::TemplateLoader.load("missing", path: dir)
      end

      assert_match(/Template not found: missing/, error.message)
    end
  end
end
