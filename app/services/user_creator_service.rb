class UserCreatorService
  def create_user(params)
    email = (params[:email] || '').strip.downcase
    password = params[:password]
    user = User.find_by_email email
    raise 'User Already Exists.' if user
    user_role = Role.where(name: 'user').first
    raise 'Missing User Role.' if user_role.blank?
    User.create! params.merge email: email,
                              password: password,
                              roles: [user_role]
  end
end
