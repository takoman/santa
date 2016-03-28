Warden::Manager.serialize_into_session(&:id)

Warden::Manager.serialize_from_session do |id|
  User.find_by_id(id)
end

# Warden::Strategies.add(:password) do
#   def valid?
#     params['email'] || params['password']
#   end
#
#   def authenticate!
#     user = User.authenticate(params['email'], params['password'])
#     user.nil? ? fail!('Could not log in') : success!(user)
#   end
# end
