#!/bin/bash
set -e
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
print_ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
print_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_err()  { echo -e "${RED}[ERROR]${NC} $1"; }

if [ "$EUID" -ne 0 ]; then print_err "Run as root"; exit 1; fi
if [ ! -f ".env" ]; then cp .env.example .env; print_warn "Edit .env then run again."; exit 1; fi
source .env
if [ -z "$DOMAIN" ]; then print_err "DOMAIN not set"; exit 1; fi
if ! command -v docker &> /dev/null; then curl -fsSL https://get.docker.com | sh; fi
sed -i "s/YOUR_DOMAIN_HERE/$DOMAIN/g" nginx/default.conf
docker compose pull && docker compose up -d
docker run --rm \
  -v $(pwd)/certbot_certs:/etc/letsencrypt \
  -v $(pwd)/certbot_www:/var/www/certbot \
  certbot/certbot certonly --webroot -w /var/www/certbot \
  -d $DOMAIN --email $EMAIL --agree-tos --no-eff-email
docker exec nginx nginx -s reload
print_ok "Done! Access: https://$DOMAIN"
