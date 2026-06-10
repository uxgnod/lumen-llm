---
name: lumen-llm-setup
description: Use when installing, configuring, or migrating the lumen-llm Ruby gem in a Ruby or Rails app, especially Rails 4/5 apps that need a lightweight OpenRouter LLM runner.
---

# lumen-llm Setup

Use this skill when a user asks to add `lumen-llm`, migrate from an internal `Lumen` module, or configure OpenRouter credentials.

## Workflow

1. Inspect the app Ruby and Rails versions before editing.
2. Add `gem "lumen-llm"` to the Gemfile.
3. Add `require "lumen_llm"` only when the app does not use Bundler autorequire.
4. For Rails, create `config/initializers/lumen_llm.rb`.
5. Configure `template_path`, `logger`, `openrouter_api_key`, `openrouter_referer`, and `openrouter_title`.
6. Choose a store:
   - no store for default no-cache behavior;
   - `MemoryStore` for local scripts and tests;
   - `RedisStore` with an app-owned Redis client for production cache/stats.
7. Add a template under `lumen_templates/`.
8. Verify with a fake provider or a single manual OpenRouter call.

## Rails Initializer Pattern

```ruby
LumenLLM.configure do |config|
  config.template_path = Rails.root.join("lumen_templates").to_s
  config.logger = Rails.logger
  config.openrouter_api_key = ENV["OPENROUTER_API_KEY"]
  config.openrouter_referer = "https://www.example.com"
  config.openrouter_title = "MyRailsApp"
end
```

## Migration Notes

- Prefer new calls as `LumenLLM.run(...)`.
- Existing `Lumen.run(...)`, `Lumen::TemplateLoader`, and `Lumen::Runner` are supported through the compatibility alias.
- Do not depend on app-specific `Settings`; pass values through `LumenLLM.configure`.

