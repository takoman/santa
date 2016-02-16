require 'spec_helper'

describe V1::Public::Endpoints::TokensEndpoint do
  include Rack::Test::Methods
  context 'with a running app and a client accessing V1::Public' do
    include_context 'with a running app and a client accessing V1::Public'

    context 'tokens' do
      let(:client_app) { Fabricate(:client_application, access_granted: true) }

      context 'POST /tokens/xapp_token' do
        context 'with a valid client application' do
          before do
            @xapp = client.tokens.xapp_token._post client_id: client_app.app_id, client_secret: client_app.app_secret
          end
          it 'returns a xapp token' do
            expect(@xapp.token).to_not be_blank
            app = ApplicationTrust.find_for_token_authentication(Trust::TOKEN_AUTH_KEY => @xapp.token)
            expect(app).to eq client_app
          end
          it 'returns type' do
            expect(@xapp.type).to eq 'xapp_token'
          end
          it 'returns expires_at' do
            expect(DateTime.parse(@xapp.expires_at)).to be > Time.now.utc
          end
        end

        context 'with invalid client_id' do
          before do
            @request = client.tokens.xapp_token._post client_id: 'invalid', client_secret: client_app.app_secret
          end
          it_behaves_like 'unauthorized' do
            let(:request) { @request }
          end
        end

        context 'with invalid client_secret' do
          before do
            @request = client.tokens.xapp_token._post client_id: client_app.app_id, client_secret: 'invalid'
          end
          it_behaves_like 'unauthorized' do
            let(:request) { @request }
          end
        end
      end
    end
  end
end
