#!/usr/bin/env sh
set -o errexit

printf "\n📦 RENDER BUILD PROCESS\n"
printf "======================\n\n"

# ==============================================================================
# 1. Instalar dependencias Ruby
# ==============================================================================
printf "1️⃣  Instalando gems Ruby...\n"
bundle install
printf "   ✅ Gems instaladas\n\n"

# ==============================================================================
# 2. Instalar dependencias JavaScript
# ==============================================================================
printf "2️⃣  Instalando dependencias JavaScript...\n"
pnpm install
printf "   ✅ JS instalado\n\n"

# ==============================================================================
# 3. Precompilar assets
# ==============================================================================
printf "3️⃣  Precompilando assets (CSS, JS)...\n"
bundle exec rails assets:precompile
printf "   ✅ Assets compilados\n\n"

# ==============================================================================
# 4. Limpiar assets antiguos
# ==============================================================================
printf "4️⃣  Limpiando assets antiguos...\n"
bundle exec rails assets:clean
printf "   ✅ Assets limpiados\n\n"

printf "✅ BUILD COMPLETADO\n"
printf "==================\n"
printf "Pendiente... Las migraciones se ejecutarán en el START command\n\n"
