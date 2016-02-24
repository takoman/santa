# == Schema Information
#
# Table name: client_applications
#
#  id             :integer          not null, primary key
#  name           :string
#  app_id         :string
#  app_secret     :string
#  access_granted :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

Fabricator(:client_application) do
  name 'MyApplication'
  app_id 'MyAppId'
  app_secret 'MyAppSecret'
  access_granted false
end
