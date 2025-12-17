# config/puma.rb

max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# ÚNICA configuración de puerto - ELIMINAR la línea `port` separada
environment ENV.fetch("RAILS_ENV") { "development" }
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Workers
workers_count = ENV.fetch("WEB_CONCURRENCY") { 0 }.to_i

if workers_count > 0
  workers workers_count
  preload_app!
  
  before_fork do
    ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
  end
  
  on_worker_boot do
    ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  end
end

# ÚNICO binding - usar solo esto
bind "tcp://0.0.0.0:#{ENV.fetch('PORT') { 3000 }}"

plugin :tmp_restart