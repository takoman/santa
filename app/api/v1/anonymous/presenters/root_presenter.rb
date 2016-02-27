module V1
  module Anonymous
    module Presenters
      module RootPresenter
        include Gris::Presenter

        link :self do
          Gris::Identity.base_url
        end

        # Additional endpoint links
        resource_links :user
      end
    end
  end
end
