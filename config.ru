require 'rack/cors'
require_relative 'config/application'
require 'grape-swagger'


# rack cors configuration
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: %i[get post put patch delete options]
  end
end

run App.new