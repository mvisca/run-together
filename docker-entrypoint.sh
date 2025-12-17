#!/bin/sh
set -e

# ==============================================================================
# Docker Entrypoint - ft_transcendence
# ==============================================================================

# Limpiar PID stale
if [ -f tmp/pids/server.pid ]; then
  rm -f tmp/pids/server.pid
fi

# Spinner
spinner='|/-\'
i=0

wait_db() {
  db_host="$1"
  db_user="$2"
  attempts=0
  max_attempts=30
  
  printf "⏳ Esperando PostgreSQL en %s" "$db_host"
  
  while ! pg_isready -h "$db_host" -U "$db_user" -t 3 >/dev/null 2>&1; do
    attempts=$((attempts + 1))
    
    if [ "$attempts" -ge "$max_attempts" ]; then
      printf "\n❌ ERROR: PostgreSQL no respondió\n"
      exit 1
    fi
    
    printf "."
    sleep 1
  done
  
  printf " ✅ Listo\n"
}

# ==============================================================================
# Detección de entorno
# ==============================================================================

if [ -n "$RENDER" ]; then
  # ============================================================================
  # PRODUCCIÓN: Render.com
  # ============================================================================
  
  printf "\n🌐 ENTORNO: Producción (Render)\n"
  printf "   Service: %s\n" "${RENDER_SERVICE_NAME:-unknown}"
  
  DATABASE_HOST=$(printf "%s" "$DATABASE_URL" | sed -n 's#.*@\([^:]*\):.*#\1#p')
  DATABASE_USER=$(printf "%s" "$DATABASE_URL" | sed -n 's#.*://\([^:]*\):.*#\1#p')
  DATABASE_NAME=$(printf "%s" "$DATABASE_URL" | sed -n 's#.*/\([^?]*\).*#\1#p')
  
  if [ -z "$DATABASE_HOST" ] || [ -z "$DATABASE_USER" ]; then
    printf "❌ ERROR: No se pudo parsear DATABASE_URL\n"
    exit 1
  fi
  
  printf "   Database: %s@%s/%s\n" "$DATABASE_USER" "$DATABASE_HOST" "$DATABASE_NAME"
  
  wait_db "$DATABASE_HOST" "$DATABASE_USER"

else
  # ============================================================================
  # DESARROLLO: Docker Local
  # ============================================================================
  
  printf "\n🐳 ENTORNO: Desarrollo (Docker Local)\n"
  printf "   Container: %s\n" "${CONTAINER_NAME:-run-together-app}"
  printf "   Database: %s@%s\n" "${DATABASE_USER:-postgres}" "${DATABASE_HOST:-db}"
  
  wait_db "${DATABASE_HOST:-db}" "${DATABASE_USER:-postgres}"
fi

# ==============================================================================
# Setup de base de datos
# ==============================================================================

printf "\n🔧 Configurando base de datos...\n"

# Crear DB solo en desarrollo
if [ -z "$RENDER" ]; then
  printf "   → Creando base de datos (si no existe)...\n"
  bundle exec rails db:create 2>/dev/null || true
fi

# Migraciones
printf "   → Ejecutando migraciones...\n"
if bundle exec rails db:migrate; then
  printf "   ✅ Migraciones completadas\n"
else
  printf "   ❌ ERROR: Falló la migración\n"
  exit 1
fi

# ==============================================================================
# Seeds condicionales (SOLO EN DESARROLLO)
# ==============================================================================

if [ "$AUTO_SEED" = "true" ] && [ -z "$RENDER" ]; then
  printf "\n🌱 Ejecutando seeds (AUTO_SEED=true)...\n"
  
  if [ "$SEED_MODE" = "destructive" ]; then
    printf "   ⚠️  MODO DESTRUCTIVO\n"
  else
    printf "   ℹ️  MODO SEGURO\n"
  fi
  
  if bundle exec rails db:seed; then
    printf "   ✅ Seeds completados\n"
  else
    printf "   ⚠️  Advertencia: Falló el seed\n"
  fi
else
  printf "\nℹ️  Saltando seeds (producción o AUTO_SEED=false)\n"
fi

# ==============================================================================
# Iniciar aplicación
# ==============================================================================

printf "\n🚀 Iniciando aplicación Rails...\n"
printf "   Rails env: %s\n" "${RAILS_ENV:-development}"
printf "   Port: %s\n\n" "${PORT:-3000}"

# Crear directorios necesarios para Puma
mkdir -p tmp/pids tmp/sockets

# En producción: SOLO Puma (sin Foreman)
# En desarrollo: Foreman con JS/CSS watch
if [ -n "$RENDER" ]; then
  # PRODUCCIÓN: Solo Puma
  exec bundle exec puma -C config/puma.rb
else
  # DESARROLLO: Foreman con todos los procesos
  exec bundle exec foreman start -f Procfile.dev
fi