#!/bin/bash
set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
print_ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
print_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_err()  { echo -e "${RED}[ERROR]${NC} $1"; }

if [ "$EUID" -ne 0 ]; then print_err "Execute como root (sudo)."; exit 1; fi
if [ ! -f ".env" ]; then cp .env.example .env; print_warn "Arquivo .env criado. Edite-o e rode o script novamente."; exit 1; fi

source .env
if [ -z "$DOMAIN" ]; then print_err "A variável DOMAIN não está configurada no seu .env"; exit 1; fi

#1. Ensure that Docker is installed.
if ! command -v docker &> /dev/null; then 
    print_warn "Docker não encontrado. Instalando..."
    curl -fsSL https://get.docker.com | sh
fi

#2. Configure the domain in Nginx
if [ -f "nginx/default.conf" ]; then
    sed -i "s/YOUR_DOMAIN_HERE/$DOMAIN/g" nginx/default.conf
fi

# Defining the path where the actual certificate should be located
CERT_VALIDATION_PATH="$(pwd)/certbot_certs/live/$DOMAIN/fullchain.pem"

#3. SOLVING THE PARADOX: Generate the certificate BEFORE starting Nginx
if [ ! -f "$CERT_VALIDATION_PATH" ]; then
    print_warn "Certificado SSL não encontrado para o domínio $DOMAIN."
    print_warn "Iniciando Certbot em modo Standalone para validação inicial..."
    
    # Ensures door 80 is clear by knocking down any remaining containers.
    docker compose down || true
    
# Runs Certbot standalone, creating a temporary server on port 80
    docker run --rm \
      -p 80:80 \
      -v "$(pwd)/certbot_certs:/etc/letsencrypt" \
      certbot/certbot certonly --standalone \
      -d "$DOMAIN" --email "$EMAIL" --agree-tos --no-eff-email

    print_ok "Certificado SSL gerado com sucesso em certbot_certs!"
else
    print_ok "Certificado SSL válido já encontrado. Pulando etapa de geração."
fi

#4. Now that the certificates exist, the stack can be deployed without breaking Nginx.
print_warn "Baixando imagens e iniciando a AI Stack..."
docker compose pull && docker compose up -d

print_ok "Tudo pronto e rodando perfeitamente!"
print_ok "Acesse a sua interface em: https://$DOMAIN"
