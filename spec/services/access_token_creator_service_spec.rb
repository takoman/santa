require 'spec_helper'

describe AccessTokenCreatorService do
  let(:access_token_creator) { AccessTokenCreatorService.new }
  let(:client_app) { Fabricate(:client_application, access_granted: true) }
  let(:user_password) { 'pickeerocks' }
  let(:user) { Fabricate(:user, email: 'chung-yi@mypickee.com', password: user_password) }
  let(:params) do
    {
      client_id: client_app.app_id,
      client_secret: client_app.app_secret,
      grant_type: 'credentials',
      email: user.email,
      password: user_password
    }
  end

  shared_examples 'failed to create access token' do
    let(:access_token_creator) { subject }
    let(:status) { 400 }
    it 'raises gris error' do
      response = { status: status, message: message }
      expect do
        access_token_creator.create_access_token invalid_params
      end.to throw_symbol :error, message: response, status: status
    end
  end

  context 'with invalid client_id' do
    it_behaves_like 'failed to create access token' do
      let(:invalid_params) { params.merge client_id: 'no-this-client-id' }
      let(:message) { 'Invalid client_id or client_secret' }
    end
  end

  context 'with invalid client_secret' do
    it_behaves_like 'failed to create access token' do
      let(:invalid_params) { params.merge client_secret: 'invalid-client-secret' }
      let(:message) { 'Invalid client_id or client_secret' }
    end
  end

  context 'with invalid client_secret' do
    it_behaves_like 'failed to create access token' do
      let(:invalid_params) { params.merge grant_type: 'no-this-grant-type' }
      let(:message) { 'Unsupported grant type: no-this-grant-type' }
    end
  end

  context 'with credentials grant type' do
    context 'with blank email' do
      it_behaves_like 'failed to create access token' do
        let(:invalid_params) { params.merge email: '' }
        let(:message) { 'Missing email' }
      end
    end

    context 'with blank password' do
      it_behaves_like 'failed to create access token' do
        let(:invalid_params) { params.merge password: '' }
        let(:message) { 'Missing password' }
      end
    end

    context 'with unregistered email' do
      it_behaves_like 'failed to create access token' do
        let(:invalid_params) { params.merge email: 'no-this-user@email.com' }
        let(:message) { 'Invalid email' }
      end
    end

    context 'with incorrect password' do
      it_behaves_like 'failed to create access token' do
        let(:invalid_params) { params.merge password: 'wrong-password' }
        let(:message) { 'Invalid password' }
      end
    end

    it 'creates an access token properly' do
      access_token = subject.create_access_token params
      expect(access_token[:access_token]).to_not be_blank
      trusted_user, application = UserTrust.find_for_token_authentication(
        Trust::TOKEN_AUTH_KEY => access_token[:access_token]
      )
      expect(application).to eq client_app
      expect(trusted_user).to eq user
      expect(access_token[:expires_at]).to be > Time.now.utc
    end
  end
end
