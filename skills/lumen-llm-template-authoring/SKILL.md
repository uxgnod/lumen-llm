---
name: lumen-llm-template-authoring
description: Use when creating or reviewing lumen-llm YAML prompt templates, especially templates that require JSON output and Ruby 2.3/Rails 4 compatibility.
---

# lumen-llm Template Authoring

Use this skill when writing templates under `lumen_templates/` or `examples/templates/`.

## Template Shape

```yaml
key: translator
model: openai/gpt-5-mini
provider: openrouter
output_type: json

system_prompt: |
  Return only valid JSON.

user_prompt: |
  Input: {{input_json}}
```

## Rules

- Use `{{variable_name}}` placeholders.
- Pass structured data as JSON strings from Ruby.
- Set `output_type: json` only when the model is instructed to return raw JSON.
- Tell the model not to wrap JSON in markdown.
- Preserve placeholders and product names when translating UI copy.
- Keep templates app-specific; the gem should only ship generic examples.

## Test Pattern

Use `LumenLLM::TemplateLoader.load` to load the template and `template.render(input)` to verify the rendered messages. Use a fake provider for full runner tests.

