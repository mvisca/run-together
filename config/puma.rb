# Puma config file
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 3 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count


# Workertimeout
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
port ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

if ENV.fetch("RAILSENV") == "production"

	workers_count = ENV.fetch("WEB_CONCURRENCY") { 0 }.to_i
	workers workers_count if workers_count > 0

	if workers_count > 0
		preload_app!
		
		before_fork do
			ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
		end

		on_worker_boot do 
			ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
		end
	end
else
	workers 0
end

bind "tcp://0.0.0.0:#{ENV.fetch('PORT') { 3000 }}"

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
