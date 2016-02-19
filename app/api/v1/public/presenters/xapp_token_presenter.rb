module V1
  module Public
    module Presenters
      module XappTokenPresenter
        include Gris::Presenter

        property :type, type: String, desc: 'Token type.'
        property :token, type: String, desc: 'Token.'
        property :expires_at, type: DateTime, desc: 'Token expiration date/time.'

        link :self do
          nil
        end
      end
    end
  end
end
