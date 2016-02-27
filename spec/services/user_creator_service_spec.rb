require 'spec_helper'

describe UserCreatorService do
  let(:user_creator_service) { UserCreatorService.new }
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
  let(:user) { user_creator_service.create_user user_hash }

  context 'with email, password, and existing user role' do
    before do
      user_role
    end
    it 'creates the user with proper attributes' do
      [:name, :email, :phone, :gender, :notes].each do |attr|
        expect(user.send(attr)).to eq user_hash[attr]
      end
      expect(user.authenticate(user_hash[:password])).to eq user
      expect(user.birthday.iso8601).to eq user_hash[:birthday]
    end
    it 'creates the user with proper role' do
      expect(user.roles).to eq [user_role]
    end
  end
  context 'without existing user role' do
    it 'raises an error' do
      expect do
        user
      end.to raise_error RuntimeError, 'Missing User Role.'
    end
  end
  context 'with existing user' do
    before do
      Fabricate(:user, user_hash)
    end
    it 'raises an error' do
      expect do
        user
      end.to raise_error RuntimeError, 'User Already Exists.'
    end
  end
end
