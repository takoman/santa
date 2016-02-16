require 'spec_helper'

describe ApplicationTrust, type: :model do
  context 'create_for_token_authentication' do
    it 'raises an error when application is missing' do
      expect do
        ApplicationTrust.create_for_token_authentication({})
      end.to raise_error(RuntimeError, 'missing application')
    end
  end
  context 'find_for_token_authentication' do
    it 'raises an error when token is missing' do
      expect do
        ApplicationTrust.find_for_token_authentication({})
      end.to raise_error(RuntimeError, 'missing trust_token')
    end
  end
  context 'an application' do
    before do
      @application = Fabricate :client_application, access_granted: true
    end
    it 'generates a token' do
      token = ApplicationTrust.create_for_token_authentication(application: @application)
      expect(token.length).to be > 0
      auth = ApplicationTrust.find_for_token_authentication('trust_token' => token)
      expect(auth).to eq(@application)
    end
  end
  context 'a disabled application' do
    before do
      @application = Fabricate :client_application
    end
    it 'does not generate a token' do
      expect do
        ApplicationTrust.create_for_token_authentication(application: @application)
      end.to raise_error 'application is disabled'
    end
  end
end
