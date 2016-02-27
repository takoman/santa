# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ActiveRecord::Base
  ROLES = %w(user partner admin).freeze

  validates :name, presence: true,
                   uniqueness: true,
                   inclusion: { in: ROLES }

  has_and_belongs_to_many :users, -> { uniq }
end
