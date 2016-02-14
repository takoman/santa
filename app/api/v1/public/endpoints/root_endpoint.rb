module V1
  module Public
    module Endpoints
      class RootEndpoint < Grape::API
        format :json
        formatter :json, Grape::Formatter::Roar
        content_type :json, 'application/hal+json'
        version 'v1-public', using: :header, vendor: 'santa'
        cascade true

        desc 'Get the Root API Endpoint'
        get do
          present self, with: V1::Public::Presenters::RootPresenter
        end

        # Additional mounted endpoints
      end
    end
  end
end
