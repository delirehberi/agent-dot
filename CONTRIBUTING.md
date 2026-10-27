# Contributing to `agent-dots`

Thank you for your interest in contributing to `agent-dots`!

## Core Guidelines

1. **Zero Personal Paths or Secrets:**
   - Never hardcode user-specific directories, local project paths, or private domains in templates or markdown files.
   - Parameterize environment-specific values in `.tpl` files using `${VARIABLE_NAME}` syntax and document dummy placeholders in `.env.secrets.example`.
2. **Directive Clarity:**
   - Keep language directives (`languages.d/*.md`) and DevOps directives (`devops.d/*.md`) concise, actionable, and focused on production-grade idioms and security.
   - Communicate exclusively in English across all documentation, plans, and directives.
3. **Verification Before Submitting:**
   - Run `make check` (or `make dev`) before opening a pull request to verify:
     - `manage.sh` syntax (`bash -n`)
     - Valid JSON in `claude/settings.json`
     - Zero hardcoded personal paths or private endpoints
     - Complete coverage of template variables in `.env.secrets.example`

## Adding a New Language or Framework Directive

1. Create `languages.d/<language>.md` or `devops.d/<platform>.md`.
2. Register the file and its detection triggers under `## Language & Stack Directives` in `AGENTS.md`.
3. Run `make check` to ensure all repository checks pass.
