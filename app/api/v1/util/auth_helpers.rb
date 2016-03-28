module V1
  module Util
    module AuthHelpers
      def warden
        env['warden']
      end

      def current_user
        warden.user
      end

      def xapp_token_authenticate!
        gris_error!('An application token is required.', 401) unless env['xapp.application']
      end

      def user_authenticate!
        gris_error!('A user is required.', 401) unless current_user
      end
    end
  end
end
