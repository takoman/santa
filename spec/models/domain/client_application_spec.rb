require 'spec_helper'

describe ClientApplication, type: :model do
  it 'requires a name' do
    expect(ClientApplication.new).not_to be_valid
    expect(ClientApplication.new(name: 'name')).to be_valid
  end
  describe 'a client application' do
    before do
      @client_app = Fabricate(:client_application)
    end
    it 'generates a 20 digit id' do
      expect(@client_app.app_id.size).to eq(20)
    end
    it 'generates a 32 digit string' do
      expect(@client_app.app_secret.size).to eq(32)
    end
    it "doesn't reuse ids and keys" do
      applications = { @client_app.app_id => @client_app.app_secret }
      5.times do
        client_application = Fabricate(:client_application)
        expect(applications.keys).not_to include client_application.app_id
        expect(applications.values).not_to include client_application.app_secret
        applications[client_application.app_id] = client_application.app_secret
      end
    end
  end
  describe '#self.authenticate' do
    before do
      @client_app = Fabricate(:client_application)
    end
    context 'with granted access' do
      it 'does not authenticate' do
        expect(ClientApplication.authenticate(@client_app.app_id, @client_app.app_secret)).to be nil
      end
    end
    context 'with granted access' do
      before do
        @client_app.update access_granted: true
      end
      it 'does not authenticate with an invalid id' do
        expect(ClientApplication.authenticate('invalid', @client_app.app_secret)).to be nil
      end
      it 'does not authenticate with an invalid secret' do
        expect(ClientApplication.authenticate(@client_app.app_id, 'invalid')).to be nil
      end
      it 'returns an instance of ClientApplication' do
        expect(ClientApplication.authenticate(@client_app.app_id, @client_app.app_secret)).to eq @client_app
      end
    end
  end
  describe '#self.xapp_json' do
    before do
      @client_app = Fabricate(:client_application, access_granted: true)
    end
    it 'returns nil if no authenticated app' do
      expect(ClientApplication.xapp_json('invalid', 'invalid')).to be nil
    end
    it 'returns xapp_token and expires_in' do
      Timecop.freeze Time.now
      xapp_json = ClientApplication.xapp_json @client_app.app_id, @client_app.app_secret
      app = ApplicationTrust.find_for_token_authentication('trust_token' => xapp_json['xapp_token'])
      expect(app).to eq @client_app
      expect(xapp_json['expires_in']).to eq ClientApplication::XAPP_EXPIRES_IN.from_now.as_json
    end
  end
end
