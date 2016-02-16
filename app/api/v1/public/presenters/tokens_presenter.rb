module V1
  module Public
    module Presenters
      module TokensPresenter
        include Gris::Presenter

        link :self do
          "#{Gris::Identity.base_url}/tokens"
        end

        link :xapp_token do
          "#{Gris::Identity.base_url}/tokens/xapp_token"
        end
      end
    end
  end
end
