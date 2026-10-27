# agent-dots (`~/.agents`)

Unified multi-agent dotfiles, operating directives, language-specific engineering standards, skills, and editor/CLI configuration templates for **Claude Code**, **OpenAI Codex**, **Google Gemini / Antigravity**, and **Zed**.

## Overview

`agent-dots` maintains a single source of truth (`AGENTS.md`, `languages.d/`, `devops.d/`, `skills/`, and tool templates) inside `~/.agents` and synchronizes symlinks and secret-interpolated configurations across all local AI coding agents and editors.

### Supported Tools & Symlink Targets

- **Global / Universal:** `~/AGENTS.md` -> `~/.agents/AGENTS.md`
- **Claude Code:**
  - `~/.claude/CLAUDE.md` -> `~/.agents/AGENTS.md`
  - `~/.claude/settings.json` -> `~/.agents/claude/settings.json`
  - `~/.claude/skills/<skill>` -> `~/.agents/skills/<skill>`
- **OpenAI Codex:**
  - `~/.codex/AGENTS.md` -> `~/.agents/AGENTS.md`
  - `~/.codex/config.toml` (rendered from `codex/config.toml.tpl` with `chmod 600`)
  - `~/.codex/skills/<skill>` -> `~/.agents/skills/<skill>`
- **Gemini / Antigravity:**
  - `~/.gemini/GEMINI.md` -> `~/.agents/AGENTS.md`
  - `~/.gemini/config/skills/<skill>` -> `~/.agents/skills/<skill>`
  - `~/.gemini/skills/<skill>` -> `~/.agents/skills/<skill>`
- **Zed Editor:**
  - `~/.config/zed/settings.json` (rendered from `zed/settings.json.tpl` with `chmod 600`)

## Repository Structure

```text
~/.agents/
├── AGENTS.md                 # Core operating directives, execution rules, and hygiene rules
├── Makefile                  # Standard build, verification, and deployment targets
├── manage.sh                 # Symlink synchronization, template rendering, and secret/path checks
├── figma-toggle.sh           # Shell helper (figma-on / figma-off) to toggle Figma MCPs & plugins
├── .env.secrets.example      # Template for local environment variables and MCP credentials
├── claude/
│   └── settings.json         # Claude Code CLI preferences and permissions
├── codex/
│   └── config.toml.tpl       # OpenAI Codex configuration template (including local Ollama profile)
├── devops.d/
│   └── cloudflare.md         # Cloudflare Workers & edge runtime directives
├── languages.d/
│   ├── haskell.md            # Haskell functional architecture and safety directives
│   ├── nodejs.md             # Node.js / TypeScript backend and stream/event-loop directives
│   ├── php.md                # PHP 8+ / Symfony strict typing and Clean Architecture directives
│   └── python.md             # Python typing, async resource management, and design directives
├── skills/
│   ├── bitig-planning/       # Task & roadmap tracking skill via Bitig MCP
│   ├── find-skills/          # Skill discovery helper
│   ├── graphify/             # Codebase & corpus knowledge graph builder and query skill
│   ├── hallmark/             # Anti-AI-slop frontend design & audit skill
│   └── microsoft-foundry/    # Azure AI Foundry skill suite
└── zed/
    └── settings.json.tpl     # Zed editor & ACP agent configuration template
```

## Prerequisites

- `bash` (4.0+)
- `gettext` (`envsubst` binary for rendering `.tpl` files)
- `jq` and `ripgrep` (`rg`) for running `make check` / `make dev`

## Quick Start

1. **Clone the repository into `~/.agents`:**

   ```bash
   git clone https://github.com/delirehberi/agent-dots.git ~/.agents
   cd ~/.agents
   ```

2. **Configure your local environment secrets:**

   ```bash
   cp .env.secrets.example .env.secrets
   chmod 600 .env.secrets
   ```

   Edit `.env.secrets` with your credentials and paths:
   - `FIGMA_API_KEY`: Your Figma Developer MCP token
   - `BITIG_MCP_URL`: Your Bitig MCP endpoint URL
   - `BITIG_API_TOKEN`: Your Bitig API bearer token
   - `NVM_NODE_BIN`: Path to your Node.js `bin` directory for stdio MCP servers

3. **Validate and deploy:**

   ```bash
   make dev
   make deploy
   ```

## Usage (`Makefile` & `manage.sh`)

All operations are encapsulated in the `Makefile`:

- `make dev` — Validate script syntax, verify JSON validity, ensure no hardcoded personal paths or domains leak into tracked files, and display symlink/git status.
- `make deploy` (or `make sync`) — Create/update symlinks and render `zed/settings.json.tpl` and `codex/config.toml.tpl` using `.env.secrets`.
- `make status` — Inspect active symlinks in `$HOME` and `git status` of `~/.agents`.
- `make check` — Run static checks (`bash -n`, `jq`, personal-path scan, and template variable coverage).

### Token Hygiene: Toggling Figma MCP (`figma-toggle.sh`)

Figma MCP servers and plugins are disabled by default to prevent unnecessary context/token consumption during non-UI sessions.

Source `figma-toggle.sh` in your `~/.zshrc` or `~/.bashrc`:

```bash
source ~/.agents/figma-toggle.sh
```

Then toggle Figma integrations on demand (or invoke `./figma-toggle.sh {on|off}` directly):

- `figma-on` — Enables Figma plugins/MCPs across Claude Code, OpenAI Codex, and Zed, and schedules a 45-minute desktop notification reminder.
- `figma-off` — Disables Figma plugins/MCPs and locks down plugin directories to restore token savings.

## Customizing Directives

- **Global Rules:** Edit `AGENTS.md` to adjust planning workflows, token hygiene rules, or git policies.
- **Language Stack Rules:** Add `<language>.md` under `languages.d/` or `devops.d/` and reference the trigger condition in `AGENTS.md`.
- **Editor & CLI Templates:** Edit `zed/settings.json.tpl` or `codex/config.toml.tpl` using `${VAR_NAME}` placeholders, add any new variable names to `.env.secrets.example` and `.env.secrets`, and run `make deploy`.

## License

Released under the [MIT License](LICENSE).
