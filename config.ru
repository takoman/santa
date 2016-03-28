require File.expand_path('../config/application.rb', __FILE__)

# failure_app = proc do |_env|
#   ['401', { 'Content-Type' => 'text/html' }, ['UNAUTHORIZED']]
# end

app = Rack::Builder.new do
  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  use Rack::Session::Cookie, secret: Gris.secrets.secret_key_base
  use Warden::Manager do |manager|
    # manager.default_strategies :password
    # manager.failure_app = failure_app
    manager.intercept_401 = false # so Warden won't intercept our own 401 errors.
  end
  run Santa::Application.instance
end

run app
