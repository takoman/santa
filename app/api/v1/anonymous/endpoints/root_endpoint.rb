module V1
  module Anonymous
    module Endpoints
      class RootEndpoint < Grape::API
        format :json
        formatter :json, Grape::Formatter::Roar
        content_type :json, 'application/hal+json'
        version 'v1-anonymous', using: :header, vendor: 'santa'

        use V1::Middleware::AuthMiddleware
        helpers V1::Util::AuthHelpers

        before do
          xapp_token_authenticate!
        end

        desc 'Get the root API endpoint'
        get do
          present self, with: V1::Anonymous::Presenters::RootPresenter
        end

        # Additional mounted endpoints
        mount V1::Anonymous::Endpoints::UsersEndpoint
      end
    end
  end
end
