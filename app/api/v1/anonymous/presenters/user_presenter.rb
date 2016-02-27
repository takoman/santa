module V1
  module Anonymous
    module Presenters
      module UserPresenter
        include Gris::Presenter

        property :id, writeable: false, type: String
        property :name, writeable: true, type: String
        property :email, writeable: false, type: String
        property :phone, writeable: true, type: String
        property :gender, writeable: true, type: String
        property :birthday, writeable: true, type: Date
        property :notes, writeable: true, type: String
        property :enabled, writeable: false, type: String
        property :created_at, writeable: false, type: DateTime
        property :updated_at, writeable: false, type: DateTime

        link :self do
          "#{Gris::Identity.base_url}/users/#{id}"
        end
      end
    end
  end
end
