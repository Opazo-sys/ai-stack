# 🤖 AI Stack — Self-Hosted AI on VPS

Esse projeto nasceu de uma ideia simples: por que pagar por uma IA quando dá pra hospedar a sua própria?

Sou o Opazo, estou iniciando minha carreira em infra/sysadmin e resolvi usar esse projeto pra me aprofundar em tecnologias que já uso no dia a dia como Docker, Linux, VPS... Vi outras pessoas fazendo isso, me interessei e fui atrás.

O resultado é esse stack aqui: uma IA pessoal, rodando no meu próprio servidor, sem depender de API de ninguém.

---

## Como funciona

Como funciona

1. O usuário envia uma pergunta pela interface web.
2. O Nginx recebe a requisição e atua como proxy reverso.
3. A interface Open WebUI encaminha a pergunta para o Ollama.
4. O Ollama processa a requisição utilizando o modelo local.
5. A resposta retorna pela mesma rota até o navegador.

Todos os serviços são executados em containers Docker e se comunicam por uma rede interna, sem expor diretamente os componentes ao público.

---

## O que tem aqui

| Serviço      | Imagem                              | Pra que serve                         |
|--------------|-------------------------------------|---------------------------------------|
| Ollama       | `ollama/ollama`                     | Roda o modelo de IA localmente        |
| Open WebUI   | `ghcr.io/open-webui/open-webui`     | Interface de chat no navegador        |
| SearXNG      | `searxng/searxng`                   | Busca web sem rastreamento            |
| Nginx        | `nginx:alpine`                      | Reverse proxy + HTTPS                 |

---

## O que você precisa

- VPS com pelo menos **2 vCPU / 4GB RAM** (recomendo 8GB)
- Ubuntu 22.04 ou 24.04
- Um domínio apontando pro IP da VPS
- Docker instalado (o `setup.sh` instala pra você se não tiver)

---

## Como rodar

### 1. Clone o repositório

```bash
git clone https://github.com/Opazo-sys/ai-stack.git
cd ai-stack
```

### 2. Configure o ambiente

```bash
cp .env.example .env
nano .env
```

### 3. Roda o script de setup

```bash
chmod +x setup.sh
sudo ./setup.sh
```

### 4. Puxa um modelo de IA

```bash
docker exec -it ollama ollama pull llama3.2
```

### 5. Acessa no navegador

                                  
---

## Estrutura do projeto

---

## Segurança

- HTTP redireciona automaticamente para HTTPS
- Nenhuma porta dos serviços fica exposta diretamente
- Telemetria do SearXNG desativada
- Analytics do Open WebUI desativados

---

## Atualizando

```bash
docker compose pull
docker compose up -d
```

---

## Licença

MIT
