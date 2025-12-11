#!/bin/bash
set -e

# Eliminar PID viejo de Rails (si quedó)
rm -f /app/tmp/pids/server.pid

# Ejecutar migraciones
echo "Running migrations..."
bundle exec rails db:migrate

# Compilar assets (solo en producción)
if [ "$RAILS_ENV" = "production" ]; then
  echo "Precompiling assets..."
  bundle exec rails assets:precompile
fi

# Iniciar el servidor
echo "Starting Rails server..."
exec bundle exec puma -C config/puma.rb