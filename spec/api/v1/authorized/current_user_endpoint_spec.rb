require 'spec_helper'

describe V1::Authorized::Endpoints::CurrentUserEndpoint do
  include Rack::Test::Methods
  context 'with a running app and a client accessing V1::Authorized' do
    include_context 'with a running app'

    it_behaves_like 'an endpoint with user_authenticate!', [
      ['get', '/current_user']
    ]
  end
  context 'with a running app and an authorized client and user accessing V1::Authorized' do
    include_context 'with a running app and an authorized client and user accessing V1::Authorized'

    context 'GET /current_user' do
      it 'redirects to current user' do
        response = client.current_user._get._response
        redirect_url = "#{Gris::Identity.base_url}/users/#{user.id}"
        expect(response.status).to eq 302
        expect(response.headers['Location']).to eq redirect_url
        expect(response.body).to eq({
          _links: {
            location: {
              href: redirect_url
            }
          }
        }.as_json)
      end
    end
  end
end
