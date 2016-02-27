# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  password_digest :string
#  phone           :string
#  gender          :string
#  birthday        :date
#  notes           :text
#  enabled         :boolean          default(TRUE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

Fabricator(:user) do
  name Fabricate.sequence(:name) { |i| "user-name-#{i}" }
  email Fabricate.sequence(:email) { |i| "user-#{i}@email.com" }
end
