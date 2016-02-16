module Trust
  TOKEN_AUTH_KEY = 'trust_token'.freeze

  # returns a user extracted from the token
  def self.decrypt(data)
    decrypted = begin
      Encryptor.decrypt(Base64.urlsafe_decode64(data), key: secret_key)
    rescue OpenSSL::Cipher::CipherError, ArgumentError
      return nil
    end
    trust = JSON.parse(decrypted)
    expires = trust['expires_in']
    raise 'missing expires in the trust token' if expires.blank?
    expires_t = DateTime.parse(expires)
    return nil if expires_t < DateTime.now
    trust
  end

  # creates a trust token
  def self.encrypt(data, options = {})
    expires = options[:expires_in] || (DateTime.now + 1.day)
    Base64.urlsafe_encode64(Encryptor.encrypt({
      expires_in: expires.to_s,
      salt: SecureRandom.uuid
    }.merge(data).to_json, key: secret_key))
  end

  def self.secret_key
    trust_key_value = Gris.secrets.secret_token
    raise 'missing secret token' if trust_key_value.blank?
    Digest::SHA256.hexdigest(trust_key_value)
  end
end
