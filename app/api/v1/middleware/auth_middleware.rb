module V1
  module Middleware
    class AuthMiddleware < Grape::Middleware::Base
      include Gris::ErrorHelpers
      include V1::Util::AuthHelpers

      def request
        @request ||= Grape::Request.new(env)
      end

      def before
        if access_token
          user, application = UserTrust.find_for_token_authentication(Trust::TOKEN_AUTH_KEY => access_token)
          gris_error!('The access token is invalid or has expired.', 401) unless user
          warden.set_user user, store: false
          env['xapp.application'] = application
        elsif xapp_token
          application = env['xapp.application']
          application ||= ApplicationTrust.find_for_token_authentication(Trust::TOKEN_AUTH_KEY => xapp_token)
          gris_error!('The XAPP token is invalid or has expired.', 401) unless application
          env['xapp.application'] = application unless env['xapp.application']
        end
      end

      private

      def xapp_token
        @xapp_token ||= request.params['xapp_token'] || env['HTTP_X_XAPP_TOKEN']
      end

      def access_token
        @access_token ||= request.params['access_token'] || env['HTTP_X_ACCESS_TOKEN']
      end
    end
  end
end
