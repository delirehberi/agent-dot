{
  "mcpServers": {
    "bitig": {
      "url": "${BITIG_MCP_URL}",
      "headers": {
        "Authorization": "Bearer ${BITIG_API_TOKEN}"
      }
    },
    "headroom": {
      "command": "${HEADROOM_BIN}",
      "args": [
        "mcp",
        "serve"
      ]
    }
  }
}
