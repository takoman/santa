require File.expand_path('../boot', __FILE__)

# autoload initalizers
Dir['./config/initializers/**/*.rb'].map { |file| require file }

# Autoload directories within /app
relative_load_paths = Dir.glob 'app/**/*/'
ActiveSupport::Dependencies.autoload_paths += relative_load_paths

module Santa
  class Application < Gris::Application
    config.use_error_handlers_middleware = true
    config.use_health_middleware = true

    def self.instance(*)
      super(config)
    end
  end
end
