# Puma configuration file for ft_transcendence

max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Worker timeout (development only)
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Port
port ENV.fetch("PORT") { 3000 }

# Environment
environment ENV.fetch("RAILS_ENV") { "development" }

# PID file
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# ==============================================================================
# WORKERS: Solo en producción con recursos suficientes
# ==============================================================================

# Plan gratuito Render: 512MB RAM → 0 workers (single mode)
workers_count = ENV.fetch("WEB_CONCURRENCY") { 0 }.to_i

if workers_count > 0
  workers workers_count
  
  # Solo configurar estas opciones si hay workers
  preload_app!
  
  before_fork do
    ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
  end
  
  on_worker_boot do
    ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  end
end

# ==============================================================================
# Binding
# ==============================================================================

# Escuchar en todas las interfaces (0.0.0.0 = accesible desde fuera)
bind "tcp://0.0.0.0:#{ENV.fetch('PORT') { 3000 }}"

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart