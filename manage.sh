#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="${AGENTS_DIR:-${SCRIPT_DIR}}"
SECRETS_FILE="${AGENTS_DIR}/.env.secrets"

require_secrets() {
  if [[ ! -f "${SECRETS_FILE}" ]]; then
    echo "Error: ${SECRETS_FILE} not found." >&2
    echo "Copy ${AGENTS_DIR}/.env.secrets.example to ${SECRETS_FILE} and configure your values." >&2
    exit 1
  fi
}

load_secrets_vars() {
  require_secrets
  set -a
  # shellcheck disable=SC1090
  source "${SECRETS_FILE}"
  set +a
  grep -E "^export [A-Za-z_][A-Za-z0-9_]*=" "${SECRETS_FILE}" \
    | sed -E "s/^export ([A-Za-z_][A-Za-z0-9_]*)=.*/\$\1/" \
    | tr "\n" " "
}

sync_configs() {
  local vars
  vars="$(load_secrets_vars)"

  mkdir -p \
    "${HOME}/.claude" \
    "${HOME}/.claude/skills" \
    "${HOME}/.codex" \
    "${HOME}/.codex/skills" \
    "${HOME}/.gemini" \
    "${HOME}/.gemini/config" \
    "${HOME}/.gemini/config/skills" \
    "${HOME}/.gemini/skills" \
    "${HOME}/.config/zed"

  ln -sfn "${AGENTS_DIR}/AGENTS.md" "${HOME}/AGENTS.md"
  ln -sfn "${AGENTS_DIR}/AGENTS.md" "${HOME}/.claude/CLAUDE.md"
  ln -sfn "${AGENTS_DIR}/AGENTS.md" "${HOME}/.codex/AGENTS.md"
  ln -sfn "${AGENTS_DIR}/AGENTS.md" "${HOME}/.gemini/GEMINI.md"
  ln -sfn "${AGENTS_DIR}/claude/settings.json" "${HOME}/.claude/settings.json"
  rm -f "${HOME}/.claude/agents"

  local skill_path skill_name
  for skill_path in "${AGENTS_DIR}/skills"/*; do
    [[ -d "${skill_path}" ]] || continue
    skill_name="$(basename "${skill_path}")"
    ln -sfn "${skill_path}" "${HOME}/.claude/skills/${skill_name}"
    ln -sfn "${skill_path}" "${HOME}/.codex/skills/${skill_name}"
    ln -sfn "${skill_path}" "${HOME}/.gemini/config/skills/${skill_name}"
    ln -sfn "${skill_path}" "${HOME}/.gemini/skills/${skill_name}"
  done

  if [[ -f "${AGENTS_DIR}/zed/settings.json.tpl" ]]; then
    envsubst "${vars}" < "${AGENTS_DIR}/zed/settings.json.tpl" > "${HOME}/.config/zed/settings.json"
    chmod 600 "${HOME}/.config/zed/settings.json"
  fi

  if [[ -f "${AGENTS_DIR}/codex/config.toml.tpl" ]]; then
    envsubst "${vars}" < "${AGENTS_DIR}/codex/config.toml.tpl" > "${HOME}/.codex/config.toml"
    chmod 600 "${HOME}/.codex/config.toml"
  fi

  if [[ -f "${AGENTS_DIR}/gemini/mcp_config.json.tpl" ]]; then
    envsubst "${vars}" < "${AGENTS_DIR}/gemini/mcp_config.json.tpl" > "${HOME}/.gemini/config/mcp_config.json"
    chmod 600 "${HOME}/.gemini/config/mcp_config.json"
  fi

  if [[ -f "${AGENTS_DIR}/claude/mcp.json.tpl" ]]; then
    envsubst "${vars}" < "${AGENTS_DIR}/claude/mcp.json.tpl" > "${HOME}/.claude/.mcp.json"
    chmod 600 "${HOME}/.claude/.mcp.json"
  fi
  echo "==> Synced symlinks and rendered templates from ${AGENTS_DIR}"
}

status_configs() {
  local targets=(
    "${HOME}/AGENTS.md"
    "${HOME}/.claude/CLAUDE.md"
    "${HOME}/.codex/AGENTS.md"
    "${HOME}/.gemini/GEMINI.md"
    "${HOME}/.claude/settings.json"
    "${HOME}/.claude/.mcp.json"
    "${HOME}/.codex/config.toml"
    "${HOME}/.gemini/config/mcp_config.json"
    "${HOME}/.config/zed/settings.json"
  )
  local skill_path skill_name
  for skill_path in "${AGENTS_DIR}/skills"/*; do
    [[ -d "${skill_path}" ]] || continue
    skill_name="$(basename "${skill_path}")"
    targets+=(
      "${HOME}/.claude/skills/${skill_name}"
      "${HOME}/.codex/skills/${skill_name}"
      "${HOME}/.gemini/config/skills/${skill_name}"
      "${HOME}/.gemini/skills/${skill_name}"
    )
  done
  ls -la "${targets[@]}"
  echo ""
  git -C "${AGENTS_DIR}" status -s
}

check_configs() {
  echo "==> Validating shell script syntax..."
  bash -n "${AGENTS_DIR}/manage.sh"
  bash -n "${AGENTS_DIR}/figma-toggle.sh"

  echo "==> Validating claude/settings.json..."
  jq empty "${AGENTS_DIR}/claude/settings.json"

  echo "==> Checking tracked/template files for hardcoded personal paths or domains..."
  if rg -n --glob '!.env.secrets' --glob '!.git/**' '(/home/[a-zA-Z0-9_-]+|bitig\.emre\.xyz)' "${AGENTS_DIR}"; then
    echo "Error: Found hardcoded personal path or domain in repository files." >&2
    exit 1
  fi

  echo "==> Verifying .env.secrets.example keys..."
  local tpl_vars
  tpl_vars="$(rg -o '\$\{[A-Za-z_][A-Za-z0-9_]*\}' "${AGENTS_DIR}/zed" "${AGENTS_DIR}/codex" "${AGENTS_DIR}/gemini" "${AGENTS_DIR}/claude" 2>/dev/null | sed -E 's/.*\$\{([A-Za-z_][A-Za-z0-9_]*)\}/\1/' | sort -u)"
  for var in ${tpl_vars}; do
    if ! grep -qE "^export ${var}=" "${AGENTS_DIR}/.env.secrets.example"; then
      echo "Error: Template variable \${${var}} is missing from .env.secrets.example" >&2
      exit 1
    fi
  done

  echo "==> All checks passed."
}

case "${1:-sync}" in
  sync)   sync_configs ;;
  status) status_configs ;;
  check)  check_configs ;;
  *)      echo "Usage: ./manage.sh {sync|status|check}" && exit 1 ;;
esac
