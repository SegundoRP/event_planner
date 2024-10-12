module ApplicationHelper
  def user_fullname(user)
    "#{user.first_name} #{user.last_name}"
  end
end
