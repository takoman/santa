module V1
  module Authorized
    module Presenters
      module UsersPresenter
        include Gris::PaginatedPresenter

        collection :to_a, extend: UserPresenter, as: :users, embedded: true
      end
    end
  end
end
