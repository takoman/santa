module V1
  module Authorized
    module Presenters
      module RootPresenter
        include Gris::Presenter

        link :self do
          Gris::Identity.base_url
        end

        # Additional endpoint links
        resource_links :user, [:sort]
        endpoint_link :current_user
      end
    end
  end
end
