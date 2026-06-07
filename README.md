# 🤖 Self-Hosted AI Stack

Assistente de I.A Privada.

## Stack
- **Ollama** — LLM runtime (installed on host)
- **Open WebUI** — Chat interface (Docker, port ****)
- **SearXNG** — Private web search (Docker, port ****)

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
- Open WebUI: `http://YOUR_VPS_IP:****`
- SearXNG: `http://YOUR_VPS_IP:****`
