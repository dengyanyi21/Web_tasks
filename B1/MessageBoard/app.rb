require "sinatra"
require "sqlite3"

class Message
  attr_accessor :id, :message, :author, :created_at

  def self.search_all_messages(data_base)
    messages = []
    data_base.execute( "SELECT * FROM messages ORDER BY id DESC" ) do |row|
      message = Message.new
      message.id = row[0]
      message.message = row[1]
      message.author = row[2]
      message.created_at = row[3]
      messages << message
    end
    messages
  end

  def self.search_by_id(data_base, index)
    messages = []
    data_base.execute("SELECT * FROM messages WHERE id = " + index + " ORDER BY id DESC") do |row|
      message = Message.new
      message.id = row[0]
      message.message = row[1]
      message.author = row[2]
      message.created_at = row[3]
      messages << message
    end
    messages
  end

  def self.search_by_author(data_base, author)
    messages = []
    data_base.execute("SELECT * FROM messages WHERE author = '" + author + "' ORDER BY id DESC") do |row|
      message = Message.new
      message.id = row[0]
      message.message = row[1]
      message.author = row[2]
      message.created_at = row[3]
      messages << message
    end
    messages
  end

  def self.search_by_id_author(data_base, index, author)
    messages = []
    data_base.execute("SELECT * FROM messages WHERE id = " + index + " AND author = '" + author + "' ORDER BY id DESC") do |row|
      message = Message.new
      message.id = row[0]
      message.message = row[1]
      message.author = row[2]
      message.created_at = row[3]
      messages << message
    end
    messages
  end

  def self.add_message(data_base, index, message, author, created_at)
    year = created_at.year
    month = created_at.month
    day = created_at.day
    date = "#{year}-#{month}-#{day}"
    data_base.execute("INSERT INTO messages VALUES(" + index + ", '" + message + "', '" + author + "', '" + date + "')")
  end

  def self.delete_message(data_base, index)
    data_base.execute("DELETE FROM messages WHERE id = " + index)
  end
end

if(!File::exists?("MessageBoard.db"))
  db = SQLite3::Database.open 'MessageBoard.db'
  db.execute <<-SQL
  CREATE TABLE messages(
    id INTEGER PRIMARY KEY,
    message VARCHAR(200),
    author VARCHAR(50),
    created_at DATE
  );
  SQL
else
  db = SQLite3::Database.open 'MessageBoard.db'
end
if(!File::exists?("id.txt"))
  File.open("id.txt", "w") do |file|
    file.syswrite("0")
  end
  id = 0
else
  id = File.read("id.txt").to_i
end

get '/' do
  @messages = Message.search_all_messages(db)
  erb :message_board
end

post '/search' do
  @id = params[:id]
  @author = params[:author]
  if @id.to_i.to_s == @id || @id.empty?
    if @id.empty? && @author.empty?
      redirect '/'
    elsif @id.empty?
      @messages = Message.search_by_author(db, @author)
    elsif @author.empty?
      @messages = Message.search_by_id(db, @id)
    else
      @messages = Message.search_by_id_author(db, @id, @author)
    end
    if @messages.size == 0
      erb :no_messages
    else
      erb :message_board_search
    end
  else
    erb :id_error
  end
end

post '/add' do
  message = params[:message]
  author = params[:author]
  created_at = Time.new
  if message.length >= 10 && !author.empty?
    Message.add_message(db, id.to_s, message, author, created_at)
    id += 1
    File.write("id.txt", id.to_s)
    redirect '/'
  else
    redirect '/error'
  end
end

get '/new' do
  erb :new_message
end

get '/error' do
  erb :error
end

get '/delete/:id' do
  @id = params['id']
  messages = Message.search_by_id(db, @id)
  if messages.size != 0
    Message.delete_message(db, @id)
    erb :deleteSuccess
  else
    erb :id_not_exists
  end
end