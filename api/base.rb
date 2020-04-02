module Api
  class Base < Grape::API
    prefix :api
    version 'v1', using: :path
    format :json

    mount Endpoints::Movies
    mount Endpoints::Functions
    mount Endpoints::Bookings
    mount Endpoints::Users

    add_swagger_documentation
  end
end
