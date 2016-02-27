require 'spec_helper'

describe User, type: :model do
  let(:user) { Fabricate(:user) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should have_secure_password }
  it { should validate_length_of(:password).is_at_least(8) }
  it { should allow_value('', nil).for(:password) }
  it { should have_and_belong_to_many(:roles) }

  it 'has case-insensitively unique email' do
    Fabricate(:user, name: '紀忠毅', email: 'chung-yi@gmail.com')
    %w(chung-yi@gmail.com CHUNG-YI@GMAIL.COM).each do |email|
      expect do
        Fabricate(:user, name: '紀小毅', email: email)
      end.to raise_error ActiveRecord::RecordInvalid, 'Validation failed: Email has already been taken'
    end
  end
  it 'has unique roles for each user' do
    role = Fabricate(:role)
    user.roles << role
    expect do
      user.roles << role
    end.to raise_error ActiveRecord::RecordNotUnique, /duplicate key value violates unique constraint/
  end
end
