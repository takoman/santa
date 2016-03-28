module V1
  module Authorized
    module Endpoints
      class UsersEndpoint < Grape::API
        namespace :users do
          # GET /users
          desc 'List existing users'
          params do
            optional :page, type: Integer, default: 1, desc: 'Current page.'
            optional :size, type: Integer, default: 10, desc: 'Number of users to return per page.'
            optional :sort, type: String, default: 'created_at DESC', desc: 'Sort order for accounts.'
          end
          get do
            present User.order(params[:sort]).page(params[:page]).per(params[:size]),
                    with: V1::Authorized::Presenters::UsersPresenter
          end

          # GET /users/:id
          desc 'Retrieve existing user.'
          params do
            requires :id, desc: 'ID of the user.'
          end
          get ':id' do
            user = User.find params[:id]
            present user, with: V1::Authorized::Presenters::UserPresenter
          end
        end
      end
    end
  end
end
