require "lumen_llm"

if defined?(Rails::Railtie)
  module LumenLLM
    class Railtie < Rails::Railtie
      initializer "lumen_llm.configure" do |app|
        LumenLLM.configure do |config|
          config.template_path ||= app.root.join("lumen_templates").to_s
          config.logger = Rails.logger unless config.logger_configured?
        end
      end
    end
  end
end

