module UsersHelper
  def is_admin?
    current_user === User.find_by(username: "admin")
  end
end
