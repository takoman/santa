require 'spec_helper'

describe V1::Authorized::Endpoints::UsersEndpoint do
  include Rack::Test::Methods
  context 'with a running app and a client accessing V1::Authorized' do
    include_context 'with a running app'

    it_behaves_like 'an endpoint with user_authenticate!', [
      ['get', '/users'],
      ['get', '/users/1']
    ]
  end

  context 'with a running app and an authorized client and user accessing V1::Authorized' do
    include_context 'with a running app and an authorized client and user accessing V1::Authorized'

    context 'GET /users' do
      before do
        new_users = Array.new(13) do |index|
          Fabricate(:user, created_at: index.days.ago)
        end
        # We already have a user under the context
        @users = [user] + new_users
      end
      it 'returns 10 users by default sorted by created_at DESC' do
        expect(client.users.count).to eq 10
        expect(client.users.map(&:id)).to eq @users.first(10).map(&:id)
      end
      context 'sorting' do
        it 'returns users sorted by created_at ASC' do
          results = client.users sort: 'created_at ASC'
          expect(results.count).to eq 10
          expect(results.map(&:id)).to eq @users.reverse.first(10).map(&:id)
        end
      end
      context 'pagination' do
        it 'returns pagination' do
          response = client.users page: 2, size: 3
          expect(response._links.self._url).to eq(
            "#{Gris::Identity.base_url}/users?page=2&size=3"
          )
          expect(response._links.next._url).to eq(
            "#{Gris::Identity.base_url}/users?page=3&size=3"
          )
          expect(response._links.prev._url).to eq(
            "#{Gris::Identity.base_url}/users?page=1&size=3"
          )
        end
        it 'returns paginated users' do
          results = client.users page: 2, size: 3
          expect(results.count).to eq 3
          expect(results.map(&:id)).to eq @users[3, 3].map(&:id)
        end
        it 'returns paginated sorted users' do
          results = client.users page: 2, size: 3, sort: 'created_at ASC'
          expect(results.count).to eq 3
          expect(results.map(&:id)).to eq @users.reverse[3, 3].map(&:id)
        end
      end
    end

    context 'GET /users/:id' do
      let(:user_role) { Fabricate(:role, name: 'user') }
      let(:user_hash) do
        {
          name: '紀忠毅',
          email: 'chung-yi@email.com',
          password: 'pickeerocks',
          phone: '1-4128775750',
          gender: 'M',
          birthday: '1984-12-10',
          notes: '愛喝紅茶'
        }
      end
      let(:user1) { Fabricate(:user, user_hash.merge(roles: [user_role])) }

      it 'returns the user' do
        user = client.user(id: user1.id)._get
        [:name, :email, :phone, :gender, :birthday, :notes].each do |attr|
          expect(user.send(attr)).to eq user_hash[attr]
        end
        expect(user).to_not respond_to :password
        expect(user).to_not respond_to :password_digest
      end
    end
  end
end
