// Zed settings
//
// For information on how to configure Zed, see the Zed
// documentation: https://zed.dev/docs/configuring-zed
//
// To see all of Zed's default settings without changing your
// custom settings, run `zed: open default settings` from the
// command palette
{
    "language_models": {
    "ollama": {
      "api_url": "http://localhost:11434",
      "available_models": [
        {
          "name": "qwen2.5-coder:3b",
          "display_name": "Qwen 2.5 Coder 3B (Fast Local)",
          "max_tokens": 16384,
          "supports_tools": true,
          "keep_alive": "10m"
        }
      ]
    }
  },
  "agent": {
    "show_turn_stats": true,
    "thinking_display": "preview",
    "expand_terminal_card": false,
    "expand_edit_card": false,
    "notify_when_agent_waiting": "never",
    "dock": "right",
    "favorite_models": [],
    "model_parameters": [],
    "default_model": {
      "provider": "openai",
      "model": "gpt-5-mini"
    },
    "inline_assistant_model": {
      "provider": "openai",
      "model": "gpt-5-mini"
    },
    "commit_message_model": {
      "provider": "ollama",
      "model": "qwen2.5-coder:3b"
    },
    "thread_summary_model": {
      "provider": "ollama",
      "model": "qwen2.5-coder:3b"
    },
    "compaction_model": {
      "provider": "openai",
      "model": "gpt-5-mini"
    },
    "subagent_model": {
      "provider": "openai",
      "model": "gpt-5-mini"
    },
    "auto_compact": {
      "enabled": true,
      "threshold": 35000
    }
  },
  "context_servers": {
    "figma": {
      "enabled": false,
      "remote": false,
      "command": "${NVM_NODE_BIN}/npx",
      "args": [
        "-y",
        "figma-developer-mcp",
        "--figma-api-key=${FIGMA_API_KEY}",
        "--stdio"
      ],
      "env": {
        "PATH": "${NVM_NODE_BIN}:/usr/local/bin:/usr/bin:/bin"
      }
    },
    "bitig": {
      "enabled": true,
      "url": "${BITIG_MCP_URL}",
      "headers": {
        "Authorization": "Bearer ${BITIG_API_TOKEN}"
      }
    }
  },
  "soft_wrap": "editor_width",
  "cursor_animation": {
    "enabled": true
  },
  "ui_font_weight": 400.0,
  "proxy": "",
  "diff_view_style": "unified",
  "double_click_in_multibuffer": "open",
  "agent_servers": {
    "codex-acp": {
      "default_config_options": {
        "model": "gpt-6.1-sol"
      },
      "type": "registry"
    },
    "antigravity-acp": {
      "default_config_options": {
        "mode": "auto_edit",
        "thinking_level": "medium",
        "model": "gemini-4-argon"
      },
      "type": "registry"
    },
    "claude-acp": {
      "default_config_options": {
        "mode": "auto"
      },
      "type": "registry"
    }
  },
  "outline_panel": {
    "dock": "left"
  },
  "collaboration_panel": {
    "dock": "left"
  },
  "git_panel": {
    "dock": "left"
  },
  "telemetry": {
    "diagnostics": false,
    "metrics": false
  },
  "vim_mode": true,
  "ui_font_size": 12.0,
  "buffer_font_size": 12.0,
  "theme": {
    "mode": "dark",
    "light": "One Light",
    "dark": "Gruvbox Dark Hard"
  },
  "relative_line_numbers": "enabled",
  "project_panel": {
    "dock": "left",
    "scrollbar": {
      "show": "never"
    }
  },
  "autosave": "on_focus_change",
  "tab_bar": {
    "show": false
  },
  "tabs": {
    "git_status": true
  },
  "preview_tabs": {
    "enabled": false
  },
  "tab_size": 2,
  "journal": {
    "hour_format": "hour24"
  }
}
