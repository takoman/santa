module V1
  module Public
    module Presenters
      module RootPresenter
        include Gris::Presenter

        link :self do
          Gris::Identity.base_url
        end

        # Additional endpoint links
        endpoint_link :health
        endpoint_link :tokens
      end
    end
  end
end
