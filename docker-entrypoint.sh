#!/bin/sh
set -e

# ============================================
# LIMPIEZA DE PIDS
# ============================================
rm -f tmp/pids/server.pid
rm -f tmp/pids/*.pid

# ============================================
# ESPERAR POSTGRESQL
# ============================================
echo "⏳ Esperando PostgreSQL..."
while ! pg_isready -h db -U postgres -t 3 >/dev/null 2>&1; do
  sleep 1
done
echo "✅ PostgreSQL listo"

# ============================================
# CONFIGURAR BASE DE DATOS
# ============================================
echo "🔧 Configurando base de datos..."

# Verificar si necesitamos destruir todo
if [ "$SEED_MODE" = "destructive" ]; then
  echo "   🔥 SEED_MODE=destructive detectado"
  echo "   🗑️  Destruyendo base de datos completa..."
  bundle exec rails db:drop db:create db:migrate
  echo "   ✅ Base de datos recreada desde cero"
else
  echo "   📦 Modo normal: db:prepare"
  bundle exec rails db:prepare
fi

# ============================================
# EJECUTAR SEEDS (SI AUTO_SEED=true)
# ============================================
echo "🌱 Verificando seeds..."

if [ "$AUTO_SEED" = "true" ]; then
  echo "   ✅ AUTO_SEED=true detectado"
  
  if [ "$SEED_MODE" = "destructive" ]; then
    echo "   🔥 Modo DESTRUCTIVO: db:seed limpiará todo"
  elif [ "$SEED_MODE" = "append" ]; then
    echo "   ➕ Modo APPEND: db:seed agregará datos sin limpiar"
  else
    echo "   🔄 Modo NORMAL: db:seed limpiará y recreará datos"
  fi
  
  bundle exec rails db:seed
  echo "   ✅ Seeds ejecutados exitosamente"
else
  echo "   ⏭️  AUTO_SEED no está en true, omitiendo seeds"
  echo "   💡 Para ejecutar seeds, define AUTO_SEED=true en .env"
fi

# ============================================
# INICIAR APLICACIÓN
# ============================================
echo "🚀 Iniciando aplicación..."
exec "$@"