#!/usr/bin/env bash
# Toggle Figma MCP servers and plugins across Claude Code, OpenAI Codex, and Zed.
# Source this file in ~/.bashrc or ~/.zshrc to use `figma-on` and `figma-off`,
# or invoke directly: ./figma-toggle.sh {on|off}

FIGMA_REMINDER_SECONDS=2700

# Enable Figma for Claude/Codex/Zed and schedule a 45-minute desktop reminder
figma-on() {
  chmod 755 "${HOME}/.claude/plugins/synced" 2>/dev/null || true
  claude plugin enable figma-suite@synced 2>/dev/null || true
  sed -i '/^\[plugins\."figma@openai-curated"\]$/,/^enabled =/ s/^enabled = false/enabled = true/' "${HOME}/.codex/config.toml" 2>/dev/null || true
  sed -i '/"figma": {/,/"enabled":/ s/"enabled": false/"enabled": true/' "${HOME}/.config/zed/settings.json" 2>/dev/null || true
  echo "🎨 Figma plugins ENABLED (Claude, Codex, Zed). Desktop reminder set for 45m."
  ( (sleep "${FIGMA_REMINDER_SECONDS}" && notify-send -u critical "⚠️ Token Leak Warning" "You still have Figma MCP enabled! Run 'figma-off' if you are done with UI work.") >/dev/null 2>&1 & )
}

# Lock Figma plugins and MCP servers back down
figma-off() {
  claude plugin disable figma-suite@synced 2>/dev/null || true
  chmod 000 "${HOME}/.claude/plugins/synced" 2>/dev/null || true
  sed -i '/^\[plugins\."figma@openai-curated"\]$/,/^enabled =/ s/^enabled = true/enabled = false/' "${HOME}/.codex/config.toml" 2>/dev/null || true
  sed -i '/"figma": {/,/"enabled":/ s/"enabled": true/"enabled": false/' "${HOME}/.config/zed/settings.json" 2>/dev/null || true
  echo "🔒 Figma plugins DISABLED (Claude, Codex, Zed). Token savings restored."
}

if [[ -n "${BASH_SOURCE[0]:-}" && "${BASH_SOURCE[0]}" == "${0}" ]]; then
  case "${1:-}" in
    on)  figma-on ;;
    off) figma-off ;;
    *)   echo "Usage: ${0} {on|off} (or source this file to use figma-on / figma-off)" >&2; exit 1 ;;
  esac
fi
