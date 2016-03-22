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

      context 'POST /tokens/access_token' do
        let(:params) do
          {
            client_id: client_app.app_id,
            client_secret: client_app.app_secret,
            grant_type: 'credentials'
          }
        end

        %w(client_id client_secret grant_type).each do |param|
          context "requires #{param}" do
            before do
              insufficient_params = params.reject { |k, _| k == param.to_sym }
              @request = client.tokens.access_token._post insufficient_params
            end
            it_behaves_like 'missing param' do
              let(:request) { @request }
              let(:param) { param }
            end
          end
        end
        it 'fails with invalid client_id' do
          params[:client_id] = 'invalid'
          request = client.tokens.access_token._post params
          expect(request._response.status).to eq 400
          expect(request._response.body).to eq(
            'message' => 'Invalid client_id or client_secret',
            'status' => 400
          )
        end
        it 'fails with invalid client_secret' do
          params[:client_secret] = 'invalid'
          request = client.tokens.access_token._post params
          expect(request._response.status).to eq 400
          expect(request._response.body).to eq(
            'message' => 'Invalid client_id or client_secret',
            'status' => 400
          )
        end
        it 'fails with invalid grant_type' do
          params[:grant_type] = 'verbal'
          request = client.tokens.access_token._post params
          expect(request._response.status).to eq 400
          expect(request._response.body).to eq(
            'message' => 'Unsupported grant type: verbal',
            'status' => 400
          )
        end
        context 'credentials grant type' do
          let(:user) { Fabricate(:user, email: 'chung-yi@mypickee.com', password: 'pickeerocks') }
          let(:params) do
            {
              client_id: client_app.app_id,
              client_secret: client_app.app_secret,
              grant_type: 'credentials',
              email: user.email,
              password: 'pickeerocks'
            }
          end

          it 'fails with blank email' do
            params[:email] = ''
            request = client.tokens.access_token._post params
            expect(request._response.status).to eq 400
            expect(request._response.body).to eq(
              'message' => 'Missing email',
              'status' => 400
            )
          end
          it 'fails with blank password' do
            params[:password] = ''
            request = client.tokens.access_token._post params
            expect(request._response.status).to eq 400
            expect(request._response.body).to eq(
              'message' => 'Missing password',
              'status' => 400
            )
          end
          it 'fails with invalid email' do
            params[:email] = 'nobody@nowhere.com'
            request = client.tokens.access_token._post params
            expect(request._response.status).to eq 400
            expect(request._response.body).to eq(
              'message' => 'Invalid email',
              'status' => 400
            )
          end
          it 'fails with invalid password' do
            params[:password] = 'invalidpassword'
            request = client.tokens.access_token._post params
            expect(request._response.status).to eq 400
            expect(request._response.body).to eq(
              'message' => 'Invalid password',
              'status' => 400
            )
          end

          context 'with valid email and password' do
            before do
              @access_token = client.tokens.access_token._post params
            end

            it 'returns an access token' do
              expect(@access_token.token).to_not be_blank
              trusted_user, application = UserTrust.find_for_token_authentication(
                Trust::TOKEN_AUTH_KEY => @access_token.token
              )
              expect(application).to eq client_app
              expect(trusted_user).to eq user
            end
            it 'returns type' do
              expect(@access_token.type).to eq 'access_token'
            end
            it 'returns expires_at' do
              expect(DateTime.parse(@access_token.expires_at)).to be > Time.now.utc
            end
          end
        end
      end
    end
  end
end
