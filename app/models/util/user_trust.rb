# A trust is an encrypted blob that contains a user identity
module UserTrust
  # returns a user and an application extracted from the token
  def self.find_for_token_authentication(options)
    trust_token = options[Trust::TOKEN_AUTH_KEY]
    raise "missing #{Trust::TOKEN_AUTH_KEY}" if trust_token.blank?
    trust = Trust.decrypt trust_token
    return nil unless trust
    application = nil
    application_id = trust['application_id']
    if application_id
      application = ClientApplication.find application_id
      return nil unless application && application.access_granted?
    end
    user_id = trust['user_id']
    raise 'missing user_id in the trust token' if user_id.blank?
    user = User.find user_id
    # If a user is disabled, the auth token expires.
    return nil unless user && user.enabled?
    # If the password changes, the auth token expires.
    password_digest = trust['password_digest']
    return nil if user.password_digest && user.password_digest != password_digest
    [user, application]
  end

  # creates a trust token
  def self.create_for_token_authentication(options)
    user = options[:user]
    raise 'missing user' unless user
    raise 'user is disabled' unless user.enabled?

    data = {
      id: SecureRandom.hex(10),
      user_id: user.id.to_s,
      password_digest: user.password_digest,
    }
    if options[:application]
      application = options[:application]
      raise 'application is disabled' unless application.access_granted?
      data[:application_id] = application.id.to_s
    end
    Trust.encrypt(data, options)
  end
end
