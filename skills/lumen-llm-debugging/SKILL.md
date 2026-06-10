---
name: lumen-llm-debugging
description: Use when debugging lumen-llm failures involving template loading, OpenRouter requests, JSON parsing, cache behavior, or Rails integration.
---

# lumen-llm Debugging

Use this skill when a user reports a failing `LumenLLM.run` call.

## Checklist

1. Confirm the template path and template key.
2. Render the template locally with `bin/debug-template`.
3. Check `OPENROUTER_API_KEY` or explicit `config.openrouter_api_key`.
4. Confirm the model name is available through OpenRouter.
5. If JSON parsing fails, inspect the raw response content for markdown fences or explanations.
6. If cache seems stale, retry with `force: true`.
7. If Rails integration fails, require `lumen_llm` and inspect the initializer.

## Useful Commands

```sh
bin/test
bin/debug-template examples/templates/translator.yml examples/inputs/translator.json
ruby -Ilib -e 'require "lumen_llm"; p LumenLLM.configuration'
```

## Common Causes

- Missing template path.
- Template filename does not match the key passed to `LumenLLM.run`.
- The model returned non-JSON while `output_type: json` was set.
- Redis was assumed to exist but no store was configured.
- Rails app used `Settings.openrouter`; migrate to explicit `LumenLLM.configure`.

