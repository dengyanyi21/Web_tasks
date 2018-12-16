require 'sinatra'
require 'mysql2'
require 'active_record'
require 'digest/sha1'
require_relative 'db/connection'
require_relative 'models/user_operate'
require_relative 'models/message_operate'

use Rack::Session::Pool, expire_after: 120

configure do
  enable :sessions
end

get '/login' do
  if session[:admin]
    redirect '/'
  else
    erb :login
  end
end

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

get '/signup' do
  erb :signup
end

post '/signup' do
  if UserOperate.create(params[:username], Digest::SHA1.hexdigest(params[:password]))
    redirect '/login'
  else
    erb :error_user
  end
end

get '/' do
  if session[:admin]
    temp_messages = Message.all.order(created_at: :desc)
    @contents = MessageOperate.build_content(temp_messages)
    erb :message_board
  else
    redirect '/login'
  end
end

post '/search' do
  if session[:admin]
    temp_username = params[:username]
    if temp_username.empty?
      redirect '/'
    else
      user = User.find_by(username: temp_username)
      if user
        temp_messages = Message.where(user_id: user.id).order(created_at: :desc)
        @contents = MessageOperate.build_content(temp_messages)
        if @contents.size == 0
          erb :no_messages
        else
          erb :message_board_search
        end
      else
        erb :no_messages
      end
    end
  else
    redirect '/login'
  end
end

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

get '/new' do
  if session[:admin]
    erb :new_message
  else
    redirect '/login'
  end
end

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

get '/profile' do
  if session[:admin]
    temp_user_id = session[:user_id]
    @contents = Message.where(user_id: temp_user_id).order(created_at: :desc)
    @username = User.find_by(id: temp_user_id).username
    erb :profile
  else
    redirect '/login'
  end
end

get '/change_password' do
  if session[:admin]
    erb :change_password
  else
    redirect '/login'
  end
end

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

get '/logout' do
  session.clear
  redirect '/login'
end

after do
  ActiveRecord::Base.connection.close
end