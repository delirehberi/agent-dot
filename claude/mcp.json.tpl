{
  "mcpServers": {
    "bitig": {
      "type": "http",
      "url": "${BITIG_MCP_URL}",
      "headers": {
        "Authorization": "Bearer ${BITIG_API_TOKEN}"
      }
    },
    "headroom": {
      "type": "stdio",
      "command": "${HEADROOM_BIN}",
      "args": [
        "mcp",
        "serve"
      ]
    }
  }
}
