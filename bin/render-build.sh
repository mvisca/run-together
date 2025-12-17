#!/usr/bin/env bash
set -o errexit

echo "📦 Instalando gems..."
bundle install

echo "📦 Instalando JS dependencies..."
pnpm install

echo "🔨 Precompilando assets..."
bundle exec rails assets:precompile

echo "🧹 Limpiando assets antiguos..."
bundle exec rails assets:clean

echo "✅ Build completado"