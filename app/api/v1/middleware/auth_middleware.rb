module V1
  module Middleware
    class AuthMiddleware < Grape::Middleware::Base
      include Gris::ErrorHelpers

      def request
        @request ||= Grape::Request.new(env)
      end

      def before
        if xapp_token
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
    end
  end
end
