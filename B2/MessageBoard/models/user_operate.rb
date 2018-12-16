require_relative 'user'

class UserOperate
  def self.create(temp_username, temp_password)
    user = User.new do |u|
      u.username = temp_username
      u.password = temp_password
    end
    user.save
  end

  def self.change_password(temp_old_password, temp_new_password, session_id)
    user = User.find_by(id: session_id)
    if temp_old_password == user.password
      user.password = temp_new_password
      user.save
    else
      return false
    end
  end
end