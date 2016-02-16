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

class ClientApplication < ActiveRecord::Base
  # An open client can continue making requests for the duration of XAPP_EXPIRES_IN.
  XAPP_EXPIRES_IN = 1.week

  validates :name, presence: true

  before_create :generate_secrets

  def self.authenticate(app_id, app_secret)
    app = where(app_id: app_id, app_secret: app_secret).first
    return app if app && app.access_granted?
  end

  def self.xapp_json(client_id, client_secret)
    app = authenticate(client_id, client_secret)
    return nil unless app
    expires_in = XAPP_EXPIRES_IN.from_now
    token = ApplicationTrust.create_for_token_authentication(application: app, expires_in: expires_in)
    {
      xapp_token: token,
      expires_in: expires_in
    }.as_json
  end

  def generate_secrets
    self.app_id = SecureRandom.hex 10
    self.app_secret = SecureRandom.hex 16
  end
end
