require 'spec_helper'

describe V1::Anonymous::Endpoints::UsersEndpoint do
  include Rack::Test::Methods
  context 'with a running app and a client accessing V1::Anonymous' do
    include_context 'with a running app'

    it_should_behave_like 'an endpoint with xapp_token_authentication!', [
      ['post', '/users', 'Accept', 'application/vnd.santa-v1-anonymous+json'],
      ['get', '/users/1', 'Accept', 'application/vnd.santa-v1-anonymous+json']
    ]
  end

  context 'with a running app and an authorized client accessing V1::Anonymous' do
    include_context 'with a running app and an authorized client accessing V1::Anonymous'

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

    context 'POST /users' do
      before do
        user_role
      end
      it 'creates a user' do
        expect do
          client.users._post user: user_hash
        end.to change { User.count }.by(1)
      end
      it 'returns a user' do
        user = client.users._post user: user_hash
        [:name, :email, :phone, :gender, :birthday, :notes].each do |attr|
          expect(user.send(attr)).to eq user_hash[attr]
        end
        expect(user).to_not respond_to :password
        expect(user).to_not respond_to :password_digest
      end
      it 'requires a name' do
        user_hash_without_name = user_hash.reject { |k, _| k == :name }
        request = client.users._post user: user_hash_without_name
        expect(request._response.body).to eq(
          'error' => 'user[name] is missing'
        )
      end
      it 'requires an email' do
        user_hash_without_email = user_hash.reject { |k, _| k == :email }
        request = client.users._post user: user_hash_without_email
        expect(request._response.body).to eq(
          'error' => 'user[email] is missing'
        )
      end
      it 'requires a password' do
        user_hash_without_password = user_hash.reject { |k, _| k == :password }
        request = client.users._post user: user_hash_without_password
        expect(request._response.body).to eq(
          'error' => 'user[password] is missing'
        )
      end
    end
    context 'GET /users/:id' do
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
