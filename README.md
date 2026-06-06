# 🤖 Self-Hosted AI Stack

Private AI assistant running on a Hostinger VPS.

## Stack
- **Ollama** — LLM runtime (installed on host)
- **Open WebUI** — Chat interface (Docker, port 3000)
- **SearXNG** — Private web search (Docker, port 8080)

## Setup

### 1. Install Ollama
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

### 2. Pull a model
```bash
ollama pull llama3
```

### 3. Start containers
```bash
docker compose up -d
```

## Access
- Open WebUI: `http://YOUR_VPS_IP:3000`
- SearXNG: `http://YOUR_VPS_IP:8080`
