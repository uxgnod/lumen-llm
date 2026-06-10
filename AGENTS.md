# AGENTS.md

This repo contains the `lumen-llm` Ruby gem.

## Ground Rules

- Keep runtime dependencies at zero.
- Keep Ruby syntax compatible with Ruby 2.3.
- Keep Rails support optional and compatible with Rails 4+.
- Use `LumenLLM::` as the canonical public namespace.
- Keep `Lumen::` as a compatibility alias.
- Do not add agent loops, tool calls, streaming, persistence, provider SDKs, or schema validation in v1.

## Development Commands

```sh
bin/setup
bin/test
ruby -Ilib:test test/runner_test.rb
bin/debug-template examples/templates/translator.yml examples/inputs/translator.json
gem build lumen-llm.gemspec
```

## Testing Expectations

- Use Minitest.
- Keep the Minitest development dependency below `5.16` while Ruby 2.3 is supported.
- Do not make real network calls in tests.
- Prefer fake providers, fake transports, and in-memory stores.
- Test public behavior instead of private implementation.
- Run `bin/test` before handing off changes.

## Compatibility Checklist

Before changing code, check that the change:

- avoids Ruby 2.4+ only syntax unless the support floor changes;
- does not assume Rails constants exist;
- does not assume ActiveSupport helpers exist;
- does not assume Redis is installed;
- does not require OpenRouter credentials in tests.

## Skills

Agent-facing skills live in `skills/`. Each skill must be a self-contained directory with a `SKILL.md` file containing YAML frontmatter with `name` and `description`.
