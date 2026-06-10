# Security Policy

## Supported Versions

Security fixes are provided for the latest released version of `lumen-llm`.

## Reporting a Vulnerability

Please do not open a public issue for a security vulnerability.

Email `uxgnod@gmail.com` with:

- a description of the issue;
- affected versions, if known;
- reproduction steps or proof-of-concept details;
- any suggested mitigation.

We will acknowledge the report, investigate privately, and publish a fixed release when needed.

## Security Notes

`lumen-llm` intentionally keeps runtime dependencies at zero and does not include provider SDKs, persistence, agent loops, tool calls, or streaming in v1. Tests must not make real network calls or require OpenRouter credentials.
