# Agent Directives & Operating Guidelines

## Language & Stack Directives
When working on project files, automatically apply the specific guidelines from `~/.agents/languages.d/<language>.md` matching the primary language or framework:

* **Haskell (`.hs`, `stack.yaml`, `cabal.project`):** Load `~/.agents/languages.d/haskell.md`
* **PHP / Symfony (`composer.json`, `Symfony` structure):** Load `~/.agents/languages.d/php.md`
* **Node.js (`package.json`, `.nvmrc`):** Load `~/.agents/languages.d/nodejs.md`
* **Cloudflare Workers (`wrangler.toml`, `wrangler.json`):** Load `~/.agents/devops.d/cloudflare.md`
* **Python (`pyproject.toml`, `requirements.txt`):** Load `~/.agents/languages.d/python.md`

> **Instruction:** Before generating or editing code in any language, check for the presence of the corresponding configuration file in `~/.agents/languages.d/` and adhere strictly to its principles.

## Core Principles & Execution
* **Strict Plan Adherence:** Once an implementation plan is approved, follow it exactly as agreed. Never unilaterally alter, substitute, or pivot to an alternative path—even if you believe the end result is functionally equivalent.
* **Mandatory Stop on Blockers/Errors:** If any command, API call, tool, or step fails, hits a permission error (e.g., 403 Forbidden), or encounters an unexpected constraint:
  1. **STOP** all code writing and modifications immediately.
  2. Explain the exact error and technical constraint clearly.
  3. Propose potential alternatives or request manual intervention.
  4. **WAIT** for explicit approval before proceeding with any new or modified approach.

  This covers environment, tooling, permission, network, and dependency failures, and any failure whose fix would mean leaving the approved plan. It does not cover expected failures inside the agreed work loop (a test written to fail first, a type or compile error in code just written in this step). Fix those in place.
* **Zero Silent Workarounds:** Never invent or implement workarounds for failed steps independently. Every pivot or plan modification requires mutual agreement first.

## Workflow & Planning
1. **Approval First:** Always generate a clear implementation plan and wait for explicit approval before starting implementation.
2. **Incremental Execution:** Always work step-by-step, function-by-function.
3. **Task Tracking (Bitig is the plan):** Every plan, roadmap, task list, audit or review finding is recorded as Bitig tasks via the `bitig` MCP (load the `bitig-planning` skill first).
   * **Plan mode included:** Bitig MCP calls (`list_tasks`, `add_task`, `update_task`) are planning actions, not implementation. They are explicitly allowed, and required, while in plan mode, even though plan mode forbids other writes.
   * **Order in plan mode:** (1) explore read-only, (2) create the Bitig tasks for the plan (status `todo`), (3) write the plan file as a short summary that lists the Bitig task IDs and titles, (4) only then request approval. Never request approval for a plan that has no Bitig tasks.
   * **During implementation:** set each task to `in_progress` when starting it and `complete_task` when it is verified. Steps that were skipped or not verified stay `todo`.
   * A plan file or Markdown document never replaces Bitig tasks, and tracking never goes into `ROADMAP.md`/`TASKS.md`-style files.

## Code Quality & Engineering Standards
* **Production-Grade Code:** Always generate production-ready code that adheres to industry best practices and open-source standards.
* **No `TODO`s:** Do not leave `TODO` comments in code. Take a step back, rethink the solution, and write the complete, required code immediately.
* **Security Checks:** Perform a thorough security assessment on all written or modified code.

## Environment, Build & Tooling
* **Makefiles:**
  * If a `Makefile` exists, always run tooling through it.
  * If no `Makefile` exists, propose one with standard `dev` and `deploy` targets as part of the implementation plan, and create it only once the plan is approved.
  * When executing a `make` command, do not prepend other setup commands (e.g., `nvm use`). The `Makefile` must encapsulate its own target environment setup.
* **Node.js:** For projects using `node` commands directly (outside `make`), always run `nvm use` first to load `.nvmrc` and verify the Node version before running commands. Run it in the same command as the node command (e.g. `source ~/.nvm/nvm.sh && nvm use && npm test`), because shell state does not persist between agent tool calls and `nvm` is a shell function that non-interactive shells don't load.
* **Nix:** If a `shell.nix` or `flake.nix` file is present, use `nix` commands to execute project tooling.
* **Haskell:** Do not attempt to run `ghc` tooling directly on Haskell projects.
* **Nostr Testing (`nak`):** Use the `nak` tool for testing Nostr-related tasks.
  * Always execute `nak` outside the sandbox (Claude Code: `dangerouslyDisableSandbox: true`; Gemini: `BypassSandbox: true`).
  * Always call the binary via its exact host path: `~/.local/bin/nak` so it retains full network relay and host access.
* **Debugging Tools:** Use existing CLI utilities (such as `curl`,`jq`) for debugging or verification instead of writing temporary Python/Node scripts.
* **Network Constraints:** If a URL is inaccessible on the first try, do not attempt alternative workarounds or fallbacks. Simply ask for a manual copy-paste of the content.
* **Command Errors:** If a shell command or program is inaccessible on the first try, do not attempt alternative workarounds or fallbacks. Simply ask for running by the operator itself manually and waits for response to continue. 

## Design & Communication
* **Language Constraint:** Always communicate exclusively in English, regardless of the language used in the prompt (e.g., Turkish). This includes implementation plans, which must never be prepared in any other language.
* **Diagrams:** Do not use Mermaid diagrams. Use plain text-based diagrams instead. And do not overuse diagrams. If you do not required to use diagram to explain something, do not use and use simple text or lists to show.
* **UI Components:** When building admin panels, I always prefer tailadmin and ask explicitly before using [shadcn/ui blocks](https://www.shadcnblocks.com/).
* **Design System:** when starting a new project always ask to run Hallmark design skills.

## Shell & Command Execution Constraints
* **Explicit Binary Execution:** Always invoke commands using full, explicit binary names and subcommands (e.g., `docker compose exec`, `git status`, `make`).
* **No Shell Aliases:** Do not assume interactive bash aliases (e.g., `dc`, `gs`, `m`, `gc`) exist or are available in execution environments.

## Strict Prohibitions (Never Do)
* **No `any` or loose types:** Never use `any` in TypeScript or un-typed parameters in typed languages.
* **No silent error swallowing:** Never write empty `catch` blocks or ignore promises/errors (`try { ... } catch {}`).
* **No global mutations:** Never modify global state, `process.env`, or prototypes dynamically. Exception: registering process-level handlers (`unhandledRejection`, `uncaughtException`, `SIGTERM`/`SIGINT`) once at the application entrypoint, as `nodejs.md` requires.
* **No hardcoded secrets:** Never place raw API keys, passwords, or connection strings in code—use environment variables.
* **No magic numbers/strings:** Always extract magic values into well-named constants.
* **No Upper Directory:** Never try to read files from outside of working directory. If you are allowed to one directory, do not assume to explore files in upper or home directories. Its only acceptable if me specifically ask it for. 

## Pre-Response & Verification Checklist
Before outputting any final code or implementation plan, verify the following:
1. **Dependencies:** Are all imports valid and part of existing project dependencies?
2. **Context Integrity:** Did I modify existing signatures or interfaces? If so, did I update all caller locations?
3. **Edge Cases:** Have empty states, null/undefined checks, network timeouts, and permission boundaries been explicitly handled?
4. **Imports Check:** Are there any unused or missing imports?

## Scope & Surgical Edits
* **Minimal Scope:** Touch ONLY the code necessary to implement the feature or fix the bug. Do not perform unrequested refactoring or reformat un-touched code.
* **Preserve Intent:** Keep existing comments, variable naming patterns, and code formatting intact unless explicitly told to change them.
* **Backward Compatibility:** Never break existing API contracts or public interfaces unless migration steps are agreed upon in the plan.

## Error Handling & Resiliency
* **Fail Fast & Guard Clauses:** Use early returns (`if (!data) return;`) instead of deeply nested conditional blocks.
* **Contextual Errors:** Wrap errors with descriptive context (e.g., `fmt.Errorf("fetching user %d: %w", id, err)`) rather than re-throwing raw errors.
* **Graceful Degradation:** Always define fallback states or user-facing messaging for network or service failures.

## Definition of Done (DoD)
Code is only complete when:
1. **Tests Included:** Corresponding unit or integration tests are created or updated for all new logical branches.
2. **Types Validated:** All type checks (e.g., `tsc`, `mypy`) pass without warnings.
3. **Documentation:** Non-obvious architectural decisions or subtle edge-case workarounds are documented with brief inline comments.

## Architecture & Framework Rules
* **Pattern Structure:** Follow the architecture already established in the project. For new projects, default to Clean Architecture with DDD-style domain boundaries, and confirm this in the plan.
* **State Management:** Keep logic inside services/controllers, not in raw UI components.
* **Async Operations:** Always handle cancellation tokens / abort signals for long-running, network-bound, or user-cancellable async tasks.

## GIT Related works
* **Messages:** Never add your name to commit messages. Always ask me if this tasks have tickets in JIRA or other project management tools, I will give you ticket number and you will add that to end of message like #PROJECT-NUMBER etcs. To connect commit to ticket. 
* **Commit:** Do not run commit without getting authorization or approval from me 


## Token & Context Hygiene (Global Rules)
1. **Subagent Quarantine for `bitig` MCP & Git Diffs**:
   - NEVER call `bitig` MCP tools (`mcp__bitig__*`) or run full `git diff` / `git log -p` directly in the main thread—even during Plan Mode.
   - During both Plan Mode and Implementation, always delegate `bitig` task creation (`add_task`), listing (`list_tasks`), and status updates (`update_task`, `complete_task`) to the `bitig-ops` subagent (or fast lightweight sub-task in Codex/Antigravity).
   - The subagent executes the `bitig` MCP calls and returns ONLY a dense summary (max 10 lines: task IDs, titles, and statuses) so the main thread can write the plan file without ingesting raw JSON.
2. **Targeted File Reads**:
   - Before reading unfamiliar files over 200 lines, use `rg -n` (ripgrep) to locate exact line numbers and read only the relevant line range.
   - Never read lockfiles (`flake.lock`, `package-lock.json`, `cabal.project.freeze`) or build artifacts (`dist-newstyle/`, `.direnv/`, `node_modules/`).
