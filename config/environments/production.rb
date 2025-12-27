require "active_support/core_ext/integer/time"

Rails.application.configure do
  # ============================================================================
  # CÓDIGO Y CACHING
  # ============================================================================
  
  # Las clases no se recargan entre requests (performance en producción)
  config.cache_classes = true
  
  # Carga toda la aplicación en memoria al inicio (mejor para servidores threaded)
  config.eager_load = true
  
  # Caching activado para mejor performance
  config.action_controller.perform_caching = true
  
  # ============================================================================
  # ERRORES Y DEBUGGING
  # ============================================================================
  
  # No mostrar stack traces completos a usuarios (seguridad)
  config.consider_all_requests_local = false
  
  # Nivel de logging: :debug, :info, :warn, :error, :fatal
  # :info es el balance entre detalle y ruido
  config.log_level = :info
  
  # Agregar request_id a cada línea de log para debugging
  config.log_tags = [:request_id]
  
  # Enviar logs a STDOUT (requerido por Render/Heroku/Docker)
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end
  
  # ============================================================================
  # SEGURIDAD Y CREDENTIALS
  # ============================================================================
  
  # Requiere RAILS_MASTER_KEY o config/master.key para desencriptar credentials
  config.require_master_key = true
  
  # Descomentar para forzar HTTPS en producción (recomendado)
  config.force_ssl = true
  
  # ============================================================================
  # ASSETS (CSS, JS, IMÁGENES)
  # ============================================================================
  
  # Servir archivos estáticos solo si la variable de entorno está presente
  # En Render: debe estar en ENV para que Puma sirva assets precompilados
  # Alternativa: usar CDN/Nginx (entonces dejar false)
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  
  # NO compilar assets en runtime (deben precompilarse en build)
  # Cambiar a true solo para debugging, nunca en producción real
  config.assets.compile = false
  
  # Compresión de CSS (descomentar si necesitas)
  # config.assets.css_compressor = :sass
  
  # ============================================================================
  # ACTIVE STORAGE (UPLOADS)
  # ============================================================================
  
  # Usar Cloudinary para archivos subidos (fotos de perfil, etc.)
  # Alternativa: :local (disco), :amazon (S3), :google (GCS)
  config.active_storage.service = :cloudinary
  
  # ============================================================================
  # ACTION CABLE (WEBSOCKETS)
  # ============================================================================
  
  # Montar Action Cable fuera del proceso principal si usas websockets
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://tu-dominio.com/cable'
  # config.action_cable.allowed_request_origins = ['https://tu-dominio.com']
  
  # ============================================================================
  # ACTION MAILER (EMAILS)
  # ============================================================================
  
  # Desactivar caching de emails en producción
  config.action_mailer.perform_caching = false
  
  # Para enviar emails reales, descomentar y configurar:
  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = { ... }
  # config.action_mailer.default_url_options = { host: 'tu-dominio.com' }
  
  # ============================================================================
  # ACTIVE JOB (BACKGROUND JOBS)
  # ============================================================================
  
  # Backend para jobs en background (descomentar si usas Sidekiq/Resque)
  # config.active_job.queue_adapter = :sidekiq
  # config.active_job.queue_name_prefix = "run_together_production"
  
  # ============================================================================
  # I18N (INTERNACIONALIZACIÓN)
  # ============================================================================
  
  # Fallback a locale por defecto si traducción no existe
  config.i18n.fallbacks = true
  
  # ============================================================================
  # DEPRECATIONS (ADVERTENCIAS DE CÓDIGO ANTIGUO)
  # ============================================================================
  
  # Notificar sobre código deprecated en lugar de imprimir warnings
  config.active_support.deprecation = :notify
  config.active_support.disallowed_deprecation = :log
  config.active_support.disallowed_deprecation_warnings = []
  
  # ============================================================================
  # BASE DE DATOS
  # ============================================================================
  
  # No generar db/schema.rb después de migraciones (opcional)
  config.active_record.dump_schema_after_migration = false
  
  # Connection pooling y estrategias de réplicas (descomentar si necesitas)
  # config.active_record.database_selector = { delay: 2.seconds }
  # config.active_record.database_resolver = ActiveRecord::Middleware::DatabaseSelector::Resolver
end