#!/usr/bin/env bash
# exit on error
set -o errexit

echo "📦 Instalando gems..."
bundle install

echo "📦 Instalando JS dependencies..."
pnpm install

echo "🔨 Precompilando assets..."
bundle exec rails assets:precompile

echo "🧹 Limpiando assets antiguos..."
bundle exec rails assets:clean

echo "🔧 Ejecutando migraciones..."
bundle exec rails db:migrate

echo "🌱 Ejecutando seeds (si AUTO_SEED=true)..."
if [ "$AUTO_SEED" = "true" ]; then
  bundle exec rails db:seed
fi

echo "✅ Build completado"