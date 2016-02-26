module V1
  module Util
    module AuthHelpers
      def xapp_token_authenticate!
        gris_error!('An application token is required.', 401) unless env['xapp.application']
      end
    end
  end
end
