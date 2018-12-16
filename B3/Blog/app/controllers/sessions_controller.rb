class SessionsController < ApplicationController
  def new
    redirect_to posts_path and return unless session[:user_id].nil?
  end

  def create
    redirect_to posts_path and return unless session[:user_id].nil?
    @temp_user = User.find_by_username(params[:username])
    if @temp_user
      @user = @temp_user.authenticate(params[:password])
      if @user
        session[:user_id] = @user.id
        redirect_to posts_path
      else
        flash[:notice] = '用户名或者密码不正确'
        render 'new'
      end
    else
      flash[:notice] = '用户名或者密码不正确'
      render 'new'
    end
  end

  def destroy
    redirect_to new_session_path and return if session[:user_id].nil?
    session[:user_id] = nil
    flash[:notice] = '退出登陆成功'
    redirect_to new_session_path
  end
end
