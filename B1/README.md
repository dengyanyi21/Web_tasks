# MessageBoard
使用`require 'sqlite3'`来加载sqlite相关的拓展。  
构造了一个Message类，有着四个属性：id、message、author、created_at。通过`attr_accessor :id, :message, :author, :created_at`同时为四个属性创建读取和写入方法。    
Message类中有六个方法，其中：  
```
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
```
这个方法通过输入一个sqlite对象，查询数据库中存储的所有数据，其中`ORDER BY id DESC`因为输入留言的时间由系统决定，所以id的排序即时间的排序，id倒序输出使得数据按照时间的倒序输出，并将数据存入messages数组中作为返回值。  
`self.search_by_id(data_base, index)``self.search_by_id(data_base, index)``self.search_by_id_author(data_base, index, author)`这三个方法则是在查询时使用条件查询的方法返回messages数组。  
```
def self.add_message(data_base, index, message, author, created_at)
  year = created_at.year
  month = created_at.month
  day = created_at.day
  date = "#{year}-#{month}-#{day}"
  data_base.execute("INSERT INTO messages VALUES(" + index + ", '" + message + "', '" + author + "', '" + date + "')")
end
```
这个方法将参数传入的各个数据构成一条数据库中的记录，然后插入数据库中。  
```
def self.delete_message(data_base, index)
  data_base.execute("DELETE FROM messages WHERE id = " + index)
end
```
这个方法将数据库中id为参数index的数据删除。  
```
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
```
这段代码首先检查数据库文件`MessageBoard.db`是否存在，若不存在则创建新文件，并创建所需的表；若存在则只打开数据库。  
```
if(!File::exists?("id.txt"))
  File.open("id.txt", "w") do |file|
    file.syswrite("0")
  end
  id = 0
else
  id = File.read("id.txt").to_i
end
```
文件`id.txt`用于保存数据库中id的下一个值，以免出现插入数据时id重复的情况出现。当文件`id.txt`不存在时，创建这个文件，并将0写入文件，同时程序变量id初始化为0；若文件存在，则将程序变量初始化为文件中存储的id的值。  
```
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
```
这段代码检查了查询留言时输入的id和author，如果id不为数字/id、author都为空/不存在查询结果的情况出现，则会有对应的界面。  
```
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
```
这段代码执行了向数据库中添加数据的操作，同时检查了新添加的数据的内容和author是否满足要求，不满足则跳转到错误界面，满足则跳转回主界面。其中`id += 1``File.write("id.txt", id.to_s)`在添加完一个数据后将下一个数据的值写入id.txt，保证数据库中数据的id不会出现错误。  
```
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
```
删除数据时会先检查将要删除的数据是否存在，存在则删除并返回删除成功的界面；不存在则返回提示数据不存的界面。  
