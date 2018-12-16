# MessageBoard
使用`require 'sinatra'` `require 'mysql2'` `require 'active_record'` `require 'digest/sha1'`来加载相关的拓展。使用`use Rack::Session::Pool, expire_after: 120`  设置session的过期时间为120秒，即登陆了成功后，120秒内无操作，session将无效  
```
configure do
  enable :sessions
end
```
这段代码启用session功能。  
构造了两个ActiveRecord模型Message和User，对应的数据库表messages和users分别有id、content、user_id、created_at和id、username、password这些属性。通过`validates`对这两个模型的数据设置数据验证，其中username不能重复，username、password、content必须存在。  
```
require 'active_record'
require 'yaml'

db_config = YAML.safe_load(File.open('db/database.yml'))
ActiveRecord::Base.establish_connection(db_config)
```
与
```
adapter: "mysql2"
host: "127.0.0.1"
username: "root"
password: "d"
database: "MessageBoard"
```
这两段代码的作用为与数据库建立连接。  
  
每个路由方法都用session中admin的是否为true进行是否已登陆的判断。  
  
```
post '/login' do
  temp_username = params[:username]
  temp_password = Digest::SHA1.hexdigest(params[:password])
  user = User.find_by(username: temp_username)
  if user != nil && user.password == temp_password
    session[:admin] = true
    session[:user_id] = user.id
    redirect '/'
  else
    erb :error_login
  end
end
```
这段代码接收用户名和密码，并用用户名查找User模型对应数据库，当用户存在且密码正确时将session[:admin]设置为true，session[:user_id]设置为当前登陆的用户的id。  
`post '/signup'`中则是接收用户名和密码，对密码进行SHA加密，并尝试存入数据库，当用户名不重复时才可将该用户信息存入数据库。  
`get '/'`中查找了所以的message数据，并将message对应的username一同存入数组进行显示。  
`post '/search'`中对输入的username进行判断，当username是已存在的用户名并且有相关的留言才显示搜索结果。  
```
post '/add' do
  if session[:admin]
    if MessageOperate.create(params[:content], session[:user_id])
      redirect '/'
    else
      erb :error_message
    end
  else
    redirect '/login'
  end
end
```
这段代码调用了操作Message的MessageOperate类中的create方法，将接收到的留言内容存入数据库，同时利用session中存储的用户id保存该留言。  
```
get '/delete/:id' do
  if session[:admin]
    if MessageOperate.delete(params['id'], session[:user_id])
      erb :deleteSuccess
    else
      erb :deleteFailed
    end
  else
    redirect '/login'
  end
end
```
这段代码调用了操作Message的MessageOperate类中的delete方法，删除留言，当留言存在并且登陆的用户是该留言的发布者时才可删除留言。  
`get '/profile'`中通过session保存的用户id找到用户名以及该用户发布的留言并显示。  
```
post '/change_password' do
  if session[:admin]
    temp_old_password = Digest::SHA1.hexdigest(params[:old_password])
    temp_new_password = Digest::SHA1.hexdigest(params[:new_password])
    if UserOperate.change_password(temp_old_password, temp_new_password, session[:user_id])
      redirect '/logout'
    else
      erb :error_password
    end
  else
    redirect '/login'
  end
end
```
这段代码调用了操作User的UserOperate类中的change_password方法,对传入的旧密码和新密码进行SHA加密，然后对比旧密码与数据库存储的用户密码，密码一致时才可用新密码对用户密码进行修改。  
```
get '/logout' do
  session.clear
  redirect '/login'
end
```
这段代码为退出登陆，它清空了session信息并返回登陆界面。  
```
after do
  ActiveRecord::Base.connection.close
end
```
这段代码使数据库的连接在不必要的时候就断开，防止同时存在过多的连接。  