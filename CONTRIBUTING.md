# Contributing

Thanks for helping improve `lumen-llm`.

## Development

Set up the project:

```sh
bin/setup
```

Run the test suite:

```sh
bin/test
bundle exec rake test
```

Check template rendering:

```sh
bin/debug-template examples/templates/translator.yml examples/inputs/translator.json
```

Check gem packaging:

```sh
gem build --strict --output /tmp/lumen-llm-0.1.0.gem lumen-llm.gemspec
```

## Compatibility Rules

- Keep runtime dependencies at zero.
- Keep Ruby syntax compatible with Ruby 2.3.
- Keep Rails support optional and compatible with Rails 4+.
- Use `LumenLLM::` as the canonical public namespace.
- Keep `Lumen::` as a compatibility alias.
- Do not add agent loops, tool calls, streaming, persistence, provider SDKs, or schema validation in v1.

## Tests

- Use Minitest.
- Do not make real network calls in tests.
- Prefer fake providers, fake transports, and in-memory stores.
- Test public behavior instead of private implementation.

## Releases

Only maintainers publish releases. Normal pushes and pull requests run CI only. RubyGems releases are triggered by `v*` tags through GitHub Actions and RubyGems Trusted Publishing.
