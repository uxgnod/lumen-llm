# lumen-llm

`lumen-llm` is a tiny Ruby LLM prompt runner for old Ruby and Rails apps.

It provides the small set of features extracted from Lumen:

- YAML prompt templates
- simple `{{variable}}` interpolation
- single-call OpenRouter chat completions
- JSON or text response parsing
- optional cache and usage stores
- optional Rails 4+ defaults

It intentionally does not provide agents, tool calls, streaming, vector search, provider SDKs, persistence, or schema validation.

## Requirements

- Ruby `>= 2.3`
- Rails `>= 4` is optional
- No runtime gem dependencies

HTTP uses Ruby stdlib `net/http`. JSON, YAML, logger, URI, digest, and date are also stdlib.

Ruby 2.3 and 2.4 are end-of-life runtimes. This gem supports them for legacy Rails apps, but new applications should use a maintained Ruby when possible.

## Installation

```ruby
gem "lumen-llm"
```

Then:

```ruby
require "lumen_llm"
```

## Configuration

For a plain Ruby app:

```ruby
LumenLLM.configure do |config|
  config.template_path = File.expand_path("lumen_templates", __dir__)
  config.openrouter_api_key = ENV["OPENROUTER_API_KEY"]
  config.openrouter_referer = "https://example.com"
  config.openrouter_title = "MyApp"
end
```

For Rails 4+:

```ruby
# config/initializers/lumen_llm.rb
LumenLLM.configure do |config|
  config.template_path = Rails.root.join("lumen_templates").to_s
  config.logger = Rails.logger
  config.openrouter_api_key = ENV["OPENROUTER_API_KEY"]
  config.openrouter_referer = "https://www.example.com"
  config.openrouter_title = "MyRailsApp"
end
```

The Railtie sets `template_path` and `logger` defaults when Rails is present, but explicit configuration is recommended.

## Templates

Create `lumen_templates/translator.yml`:

```yaml
key: translator
model: openai/gpt-5-mini
provider: openrouter
output_type: json

system_prompt: |
  You are a professional localization assistant.
  Return only valid JSON. Do not use markdown.

user_prompt: |
  Translate "{{source_text}}" into these target languages:
  {{target_languages_json}}

  Return a JSON object using the same language codes as keys.
```

Run it:

```ruby
result = LumenLLM.run(
  "translator",
  input: {
    source_text: "Save changes",
    target_languages_json: { "de" => "German", "fr" => "French" }.to_json
  }
)

puts result["de"]
```

## Compatibility Alias

The canonical namespace is `LumenLLM`.

For migrations from the original Rails-internal Lumen library, this gem also exposes:

```ruby
Lumen.run("translator", input: { ... })
Lumen::TemplateLoader.load("translator")
Lumen::Runner.new(template: template, input: input)
```

## Stores

By default, `lumen-llm` uses `LumenLLM::Stores::NullStore`, which does not cache or record stats.

Use memory store in tests or simple scripts:

```ruby
LumenLLM.configure do |config|
  config.store = LumenLLM::Stores::MemoryStore.new
end
```

Use Redis by passing an existing Redis-like client:

```ruby
redis = Redis.new(url: ENV["REDIS_URL"])

LumenLLM.configure do |config|
  config.store = LumenLLM::Stores::RedisStore.new(redis)
end
```

`lumen-llm` does not depend on the `redis` gem. Your app owns that dependency.

## Force Refresh

```ruby
LumenLLM.run("translator", input: input, force: true)
```

`force: true` bypasses the configured cache for that call.

## Development Workflow

```sh
bin/setup
bin/test
bundle exec rake test
bin/debug-template examples/templates/translator.yml examples/inputs/translator.json
```

The test suite uses Minitest and no real network calls.
Minitest is capped below `5.16` because newer Minitest releases require Ruby 2.6+.

## Agent Skills

The `skills/` directory contains Agent Skills compatible with the open `SKILL.md` format:

- `skills/lumen-llm-setup`
- `skills/lumen-llm-template-authoring`
- `skills/lumen-llm-debugging`

They help coding agents install, configure, test, and debug this gem without guessing project conventions.

## Release

Build locally:

```sh
gem build lumen-llm.gemspec
```

Publish after verifying the RubyGems name and metadata:

```sh
gem push lumen-llm-0.1.0.gem
```
