#!/bin/bash
set -e

rm -f /app/tmp/pids/server.pid

# Compile assets in development
if [ "$RAILS_ENV" != "production" ]; then
  echo "📦 Compiling assets for development..."
  yarn build
  yarn build:css
  chown -R 1000:1000 app/assets/builds || true
fi

bundle exec rails db:prepare

if [ "$RAILS_ENV" = "production" ]; then
  bundle exec rails assets:precompile
fi

# Configuración de seeds
AUTO_SEED=${AUTO_SEED:-false}
SEED_MODE=${SEED_MODE:-safe}

# En desarrollo, auto seed por defecto
if [ "$RAILS_ENV" = "development" ]; then
  AUTO_SEED=${AUTO_SEED:-true}
fi

# Ejecutar seeds si AUTO_SEED está activado
if [ "$AUTO_SEED" = "true" ]; then
  if [ "$SEED_MODE" = "destructive" ]; then
    echo "🔥 Running seeds in DESTRUCTIVE mode (drop + recreate + seed)..."
    bundle exec rails db:drop db:create db:migrate db:seed
  else
    echo "🌱 Running seeds in SAFE mode (seed only)..."
    bundle exec rails db:seed
  fi
fi

exec bundle exec puma -C config/puma.rb