require_relative "boot"
require "rails/all"

# Vincula las gemas del Gemfile
Bundler.require(*Rails.groups)

module RunTogether
  class Application < Rails::Application
    # inicializa configuracion default de rails 7.1
    config.load_defaults 7.1

    config.active_support.cache_format_version = 7.1

    config.active_record.yaml_column_permitted_classes = [
      Symbol, Date, Time, ActiveSupport::TimeWithZone,
	  ActiveSupport::HashWithIndifferentAccess
    ]

    config.time_zone = 'Madrid';
	
	config.i18n.default_locale = :en;

	config.active_storage.variant_processor = :mini_magick
  end
end
