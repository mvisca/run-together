#!/bin/bash
set -e

# Eliminar PID viejo de Rails (si quedó)
rm -f /app/tmp/pids/server.pid

echo "Waiting for database to be ready..."
# Espera hasta que la app pueda consultar la versión de la BD
until bundle exec rails db:version >/dev/null 2>&1; do
  echo "Database not ready - sleeping 1s"
  sleep 1
done

echo "Running migrations..."
bundle exec rails db:migrate

# Compilar assets (solo en producción)
if [ "$RAILS_ENV" = "production" ]; then
  echo "Precompiling assets..."
  bundle exec rails assets:precompile
fi

# Ejecutar seeds en producción si la variable RUN_SEEDS está activada.
# Cuando RUN_SEEDS=true, la BD se borra, se recrean las tablas desde 0 y se ejecutan seeds.
# Por seguridad, el valor por defecto es "false" para evitar efectos
# destructivos no deseados. Activa RUN_SEEDS=true en tu despliegue si quieres
# reproducción limpia de datos cada vez que inicia el contenedor.
if [ "$RAILS_ENV" = "production" ] && [ "${RUN_SEEDS:-false}" = "true" ]; then
  echo "Dropping database, recreating and running seeds..."
  bundle exec rails db:drop db:create db:migrate db:seed
fi

# Iniciar el servidor
echo "Starting Rails server..."
exec bundle exec puma -C config/puma.rb