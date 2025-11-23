# AGENTS.md - Dotfiles Repository Guidelines

## Build/Lint/Test Commands
- Tangle Org files to generate configs: `./tangle "$@"`
- No specific lint commands; ensure Org syntax is valid
- No tests; validate configs manually by sourcing/applying them

## Code Style Guidelines
- Use Org-mode for literate programming
- Formatting: Indent with spaces (2-4 per level)
- Naming: Descriptive section headers; consistent variable/function names
- Follow existing patterns: Mimic structure in bash.org, git.org, etc.; keep configs modular

## **Attribution Requirements**

AI agents must disclose what tool and model they are using in
the "Assisted-by" commit footer:

``` language-text
Assisted-by: [Model Name] via [Tool Name]
```

Example:

``` language-text
Assisted-by: GLM 4.6 via Claude Code
```
