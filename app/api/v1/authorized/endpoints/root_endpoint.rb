module V1
  module Authorized
    module Endpoints
      class RootEndpoint < Grape::API
        format :json
        formatter :json, Grape::Formatter::Roar
        content_type :json, 'application/hal+json'
        version 'v1-authorized', using: :header, vendor: 'santa'

        use V1::Middleware::AuthMiddleware
        helpers V1::Util::AuthHelpers

        before do
          user_authenticate!
        end

        desc 'Get the root API endpoint'
        get do
          present self, with: V1::Authorized::Presenters::RootPresenter
        end

        # Additional mounted endpoints
        mount V1::Authorized::Endpoints::UsersEndpoint
      end
    end
  end
end
