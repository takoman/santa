require 'spec_helper'

describe Trust, type: :model do
  it 'uses Gris.secrets.secret_token' do
    allow(Gris.secrets).to receive(:secret_token).and_return 'secret'
    expect(Trust.secret_key).to eq(Digest::SHA256.hexdigest('secret'))
  end
  xit "uses ENV['SECRET_TOKEN']" do
    # config/secrets.yml picked up env vars before reaching here.
    # Mark it as pending for now, and we should have a way to test
    # setting secrets.yml with env vars.
    ENV['SECRET_TOKEN'] = 'another secret'
    expect(Trust.secret_key).to eq(Digest::SHA256.hexdigest('another secret'))
  end
  it 'can decrypt an encrypted token' do
    expect(Trust.decrypt(Trust.encrypt('x' => 'y'))['x']).to eq('y')
  end
  it 'cannot decrypt a token encrypted with another key' do
    encrypted = Trust.encrypt('x' => 'y')
    allow(Gris.secrets).to receive(:secret_token).and_return 'another'
    expect(Trust.decrypt(encrypted)).to be nil
  end
  it 'expires tokens' do
    encrypted = Trust.encrypt({ 'x' => 'y' }, expires_in: 1.hour.ago)
    expect(Trust.decrypt(encrypted)).to be nil
  end
  it 'expires tokens' do
    encrypted = Trust.encrypt({ 'x' => 'y' },  expires_in: 23.hours.from_now)
    expect(Trust.decrypt(encrypted)).not_to be nil
  end
end
