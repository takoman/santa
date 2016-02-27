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

class User < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, allow_blank: true

  has_secure_password validations: false
  has_and_belongs_to_many :roles, -> { uniq }
end
