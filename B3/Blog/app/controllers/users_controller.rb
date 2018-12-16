class UsersController < ApplicationController
  def show
    redirect_to new_session_path and return if session[:user_id].nil?
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(9)
  end

  def show_comments
    redirect_to new_session_path and return if session[:user_id].nil?
    @user = User.find(session[:user_id])
    @comments = @user.comments.order(created_at: :desc).page(params[:page]).per(9)
  end

  def new
    redirect_to posts_path and return unless session[:user_id].nil?
    @user = User.new
  end

  def edit
    redirect_to new_session_path and return if session[:user_id].nil?
    @user = User.find(params[:id])
  end

  def create
    redirect_to posts_path and return unless session[:user_id].nil?
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = '注册成功,请登录'
      redirect_to new_session_path
    else
      flash[:notice] = '注册失败，出现以下错误！'
      render 'new'
    end
  end

  def update
    redirect_to new_session_path and return if session[:user_id].nil?
    @user = User.find(params[:id])
    temp_user = @user.authenticate(params.require(:user).permit(:old_password)[:old_password])
    if temp_user
      if @user.update(user_params)
        flash[:success] = '用户信息修改成功！'
      else
        flash[:failed] = '用户信息修改失败，存在以下错误！'
      end
    else
      flash[:failed] = '旧密码错误,无法进行修改！'
    end
    render 'edit'
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :email)
  end
end
