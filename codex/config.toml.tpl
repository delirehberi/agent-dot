model = "gpt-5.5"
model_reasoning_effort = "low"

[plugins."canva@openai-curated"]
enabled = false

[plugins."figma@openai-curated"]
enabled = false

[features]
memories = false

[memories]
generate_memories = false
use_memories = false

# Define local Ollama provider (uses Ollama's built-in /v1/responses compatibility)
[model_providers.local_ollama]
name = "Local Ollama"
base_url = "http://localhost:11434/v1"
wire_api = "responses"

# Optional profile if you ever run `codex --profile local` in terminal
[profiles.local]
model_provider = "local_ollama"
model = "qwen2.5-coder:3b"

