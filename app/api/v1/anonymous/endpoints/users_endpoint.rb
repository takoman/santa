module V1
  module Anonymous
    module Endpoints
      class UsersEndpoint < Grape::API
        namespace :users do
          # POST /users
          desc 'Create new user.'
          params do
            requires :user, type: Hash do
              requires :name, type: String
              requires :email, type: String
              requires :password, type: String
              optional :phone, type: String
              optional :gender, type: String
              optional :birthday, type: Date
              optional :notes, type: String
            end
          end
          post do
            user = UserCreatorService.new.create_user permitted_params[:user]
            present user, with: V1::Anonymous::Presenters::UserPresenter
          end

          # GET /users/:id
          desc 'Retrieve existing user.'
          params do
            requires :id, desc: 'ID of the user.'
          end
          get ':id' do
            user = User.find params[:id]
            present user, with: V1::Anonymous::Presenters::UserPresenter
          end
        end
      end
    end
  end
end
