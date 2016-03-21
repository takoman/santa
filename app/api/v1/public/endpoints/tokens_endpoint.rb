module V1
  module Public
    module Endpoints
      class TokensEndpoint < Grape::API
        namespace :tokens do
          # GET /tokens
          desc 'Retrieve tokens supported by this API.'
          get do
            present self, with: V1::Public::Presenters::TokensPresenter
          end

          # POST /tokens/xapp_token
          desc 'Create a new XAPP token.'
          params do
            requires :client_id, type: String, desc: 'Client id.'
            requires :client_secret, type: String, desc: 'Client secret.'
          end
          post :xapp_token do
            xapp = ClientApplication.xapp_json(params[:client_id], params[:client_secret])
            gris_error!('Unauthorized.', 401) unless xapp
            present OpenStruct.new(
              type: 'xapp_token',
              token: xapp['xapp_token'],
              expires_at: DateTime.parse(xapp['expires_in'])
            ), with: V1::Public::Presenters::XappTokenPresenter
          end

          # POST /tokens/access_token
          desc 'Create a new access token.'
          params do
            requires :client_id, type: String, desc: 'Client id.'
            requires :client_secret, type: String, desc: 'Client secret.'
            requires :grant_type, type: String, desc: 'Grant type to exchange for an access token.'
            optional :email, type: String, desc: 'Email of the user.'
            optional :password, type: String, desc: 'Password of the user.'
            all_or_none_of :email, :password
          end
          post :access_token do
            token = AccessTokenCreatorService.new.create_access_token permitted_params
            present OpenStruct.new(
              type: 'access_token',
              token: token[:access_token],
              expires_at: token[:expires_at]
            ), with: V1::Public::Presenters::AccessTokenPresenter
          end
        end
      end
    end
  end
end
