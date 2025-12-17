#!/bin/bash
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

until pg_isready -h "${DATABASE_HOST:-db}" -U "${DATABASE_USER:-postgres}"; do
  echo "Waiting for PostgreSQL..."
  sleep 2
done

bundle exec rails db:create 2>/dev/null || true
bundle exec rails db:migrate 2>/dev/null || true

exec "$@"