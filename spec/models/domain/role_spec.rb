require 'spec_helper'

describe Role, type: :model do
  let(:role) { Fabricate(:role) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should have_and_belong_to_many(:users) }
  it do
    should validate_inclusion_of(:name)
      .in_array(Role::ROLES)
  end

  it 'has unique users for each role' do
    user = Fabricate(:user)
    role.users << user
    expect do
      role.users << user
    end.to raise_error ActiveRecord::RecordNotUnique, /duplicate key value violates unique constraint/
  end
end
