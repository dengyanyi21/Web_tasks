require_relative 'message'
require_relative 'user'

class MessageOperate
  def self.create(temp_content, session_id)
    message = Message.new do |m|
      m.user_id = session_id
      m.content = temp_content
    end
    message.save
  end

  def self.delete(temp_id, session_id)
    message = Message.find_by(id: temp_id)
    if message != nil && message.user_id == session_id
      message.destroy
      return true
    else
      return false
    end
  end

  def self.build_content(temp_messages)
    user_ids = []
    id_name = {}
    temp_messages.each do |m|
      user_ids << m.user_id
    end
    user_ids.uniq!
    user_ids.each do |uid|
      name = User.find_by(id: uid).username
      id_name[uid] = name
    end
    contents = []
    temp_messages.each do |m|
      content = []
      content << m
      content << id_name[m.user_id]
      contents << content
    end
    contents
  end
end