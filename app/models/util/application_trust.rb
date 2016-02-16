# A trust is an encrypted blob that contains an application identity.
module ApplicationTrust
  # returns an application extracted from the token
  def self.find_for_token_authentication(options)
    trust_token = options[Trust::TOKEN_AUTH_KEY]
    raise "missing #{Trust::TOKEN_AUTH_KEY}" if trust_token.blank?
    trust = Trust.decrypt(trust_token)
    return nil unless trust
    application_id = trust['application_id']
    raise 'missing application_id in the trust token' if application_id.blank?
    application = ClientApplication.find(application_id)
    return nil unless application && application.access_granted?
    application
  end

  # creates a trust token
  def self.create_for_token_authentication(options)
    application = options[:application]
    raise 'missing application' unless application
    raise 'application is disabled' unless application.access_granted?
    data = {}
    data[:id] = SecureRandom.hex 10
    data[:application_id] = application.id.to_s
    Trust.encrypt(data, options)
  end
end
