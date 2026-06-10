module LumenLLM
  class Template
    attr_reader :key, :system_prompt, :user_prompt, :model, :provider, :output_type

    def initialize(key:, system_prompt:, user_prompt:, model:, provider: :openrouter, output_type: :json)
      @key = key.to_s
      @system_prompt = system_prompt.to_s
      @user_prompt = user_prompt.to_s
      @model = model.to_s
      @provider = provider.to_s
      @output_type = output_type.to_s
    end

    def render(input)
      {
        :provider => provider,
        :model => model,
        :messages => [
          { :role => "system", :content => interpolate(system_prompt, input) },
          { :role => "user", :content => interpolate(user_prompt, input) }
        ]
      }
    end

    private

    def interpolate(str, input)
      rendered = str.dup
      input.each do |key, value|
        rendered = rendered.gsub("{{#{key}}}", value.to_s)
      end
      rendered
    end
  end
end

