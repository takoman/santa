class AccessTokenCreatorService
  include Gris::ErrorHelpers

  def create_access_token(params)
    application = ClientApplication.where(app_id: params[:client_id], app_secret: params[:client_secret]).first
    gris_error!('Invalid client_id or client_secret', 400) unless application
    expires_at = Time.now + 60.days
    case params[:grant_type]
    when 'credentials' then
      email = params[:email].downcase
      gris_error!('Missing email', 400) if email.blank?
      password = params[:password]
      gris_error!('Missing password', 400) if password.blank?
      user = User.find_by email: email
      gris_error!('Invalid email', 400) unless user
      gris_error!('Invalid password', 400) unless user.authenticate(password)
      access_token = UserTrust.create_for_token_authentication(user: user, application: application, expires_at: expires_at)
    else
      gris_error!("Unsupported grant type: #{params[:grant_type]}", 400)
    end
    {
      access_token: access_token,
      expires_at: expires_at
    }
  end
end
