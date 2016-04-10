module V1
  module Authorized
    module Endpoints
      class CurrentUserEndpoint < Grape::API
        namespace :current_user do
          # GET /current_user
          desc 'Retrieve the current user.'
          get do
            redirect! "#{Gris::Identity.base_url}/users/#{current_user.id}"
          end
        end
      end
    end
  end
end
