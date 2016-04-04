require 'spec_helper'

describe UserTrust, type: :model do
  let(:user) { Fabricate :user }
  let(:disabled_user) { Fabricate :user, enabled: false }
  let(:application) { Fabricate :client_application, access_granted: true }

  context 'create_for_token_authentication' do
    it 'raises an error when user is missing' do
      expect do
        UserTrust.create_for_token_authentication({})
      end.to raise_error(RuntimeError, 'missing user')
    end
    it 'raises an error when user is disabled' do
      expect do
        UserTrust.create_for_token_authentication(user: disabled_user)
      end.to raise_error 'user is disabled'
    end
  end
  context 'find_for_token_authentication' do
    it 'raises an error when token is missing' do
      expect do
        UserTrust.find_for_token_authentication({})
      end.to raise_error(RuntimeError, 'missing trust_token')
    end
    it 'returns nil when token is expired' do
      token = UserTrust.create_for_token_authentication(
        user: user, application: application, expires_in: 1.day.from_now)
      expect(UserTrust.find_for_token_authentication('trust_token' => token)).to eq([user, application])
      Timecop.travel(2.days.from_now)
      expect(UserTrust.find_for_token_authentication('trust_token' => token)).to be nil
    end
  end
  context 'with a user' do
    let(:token) { UserTrust.create_for_token_authentication user: user }
    before { token }

    it 'generates a token' do
      expect(token.length).to be > 0
      auth = UserTrust.find_for_token_authentication('trust_token' => token)
      expect(auth).to eq [user, nil]
    end
    it "doesn't authorize after a user has been disabled" do
      user.update_attributes! enabled: false
      expect(UserTrust.find_for_token_authentication('trust_token' => token)).to be nil
    end
    it "doesn't authorize after a user's password has been changed" do
      user.update_attributes! password: 'password'
      expect(UserTrust.find_for_token_authentication('trust_token' => token)).to be nil
    end
  end
  context 'with a user and an applicaton' do
    let(:token) { UserTrust.create_for_token_authentication user: user, application: application }
    before { token }

    it 'generates a token' do
      expect(token.length).to be > 0
      expect(ApplicationTrust.find_for_token_authentication('trust_token' => token)).to eq(application)
      expect(UserTrust.find_for_token_authentication('trust_token' => token)).to eq([user, application])
    end
    it "doesn't authorize after an application is disabled" do
      application.update_attributes! access_granted: false
      expect(UserTrust.find_for_token_authentication('trust_token' => token)).to be nil
    end
  end
end
