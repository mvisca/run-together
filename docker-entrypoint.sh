#!/bin/sh
set -e

# Solo para desarrollo local - sin lógica de Render
rm -f tmp/pids/server.pid

echo "⏳ Esperando PostgreSQL..."
while ! pg_isready -h db -U postgres -t 3 >/dev/null 2>&1; do
  sleep 1
done
echo "✅ PostgreSQL listo"

echo "🔧 Configurando base de datos..."
bundle exec rails db:prepare

echo "🚀 Iniciando aplicación..."
exec "$@"