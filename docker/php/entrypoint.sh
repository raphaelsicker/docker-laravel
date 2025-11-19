#!/bin/bash
set -e

# Banco de dados
SERVICE=${DB_HOST:-mysql}

echo "Aguardando banco de dados ($SERVICE) ficar pronto..."

# Esperar o MySQL iniciar
until nc -z "$SERVICE" 3306; do
  echo "Aguardando MySQL..."
  sleep 2
done

echo "MySQL está pronto!"

# Criar .env se não existir
if [ ! -f ".env" ]; then
    echo "Criando arquivo .env..."
    cp .env.example .env
    php artisan key:generate
fi

# Instalar dependências
echo "Instalando dependências..."
composer install --ignore-platform-reqs --no-interaction

# Rodar migrations automaticamente
echo "Rodando migrations..."
php artisan migrate --force || true

echo "Iniciando PHP-FPM..."
exec php-fpm
