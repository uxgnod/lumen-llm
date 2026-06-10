require "yaml"

module LumenLLM
  class TemplateLoader
    def self.load(key, path: nil)
      new(path || LumenLLM.configuration.template_path).load(key)
    end

    def initialize(path)
      @path = path
    end

    def load(key)
      raise ConfigurationError, "template_path is not configured" if blank?(@path)

      template_file = File.join(@path.to_s, "#{key}.yml")
      raise TemplateNotFoundError, "Template not found: #{key}" unless File.exist?(template_file)

      config = YAML.load_file(template_file)
      Template.new(
        key: config["key"] || key,
        system_prompt: config["system_prompt"],
        user_prompt: config["user_prompt"],
        model: config["model"],
        provider: config["provider"] || "openrouter",
        output_type: config["output_type"] || "text"
      )
    end

    private

    def blank?(value)
      value.nil? || value.to_s.strip == ""
    end
  end
end
