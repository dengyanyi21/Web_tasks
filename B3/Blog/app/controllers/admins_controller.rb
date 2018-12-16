class AdminsController < ApplicationController
  def index
    redirect_to new_sessions_admin_path and return if session[:admin_id].nil?
    @admin = Admin.find(session[:admin_id])
    @posts = Post.all.order(audit: :asc).page(params[:page]).per(9)
    @comments = Comment.all.order(audit: :asc).page(params[:page]).per(9)
    if flash[:audit] == 'post' || flash[:audit] == nil
      redirect_to '/admins/show'
    else
      redirect_to '/admins/show_comments'
    end
  end

  def show
    redirect_to new_sessions_admin_path and return if session[:admin_id].nil?
    @admin = Admin.find(session[:admin_id])
    @posts = Post.all.order(audit: :asc).page(params[:page]).per(9)
  end

  def show_comments
    redirect_to new_sessions_admin_path and return if session[:admin_id].nil?
    @admin = Admin.find(session[:admin_id])
    @comments = Comment.all.order(audit: :asc).page(params[:page]).per(9)
  end

  def show_feedbacks
    redirect_to new_sessions_admin_path and return if session[:admin_id].nil?
    @admin = Admin.find(session[:admin_id])
    @feedbacks = Feedback.all.page(params[:page]).per(9)
  end

  def new
    redirect_to admins_path and return unless session[:admin_id].nil?
    @admin = Admin.new
  end

  def create
    redirect_to admins_path and return unless session[:admin_id].nil?
    temp_admin_code = params[:admin_code]
    @admin = Admin.new
    @admin.username = params[:username]
    @admin.password = params[:password]
    @admin.password_confirmation = params[:password_confirmation]
    if temp_admin_code == 'uAiqw'
      if @admin.save
        flash[:notice] = '注册成功,请登录'
        redirect_to new_sessions_admin_path
      else
        flash[:notice] = '注册失败，出现以下错误！'
        render 'new'
      end
    else
      flash[:notice] = '注册失败，管理员注册码错误！'
      render 'new'
    end
  end

  private

  def admin_params
    params.require(:admin).permit(:username, :password, :password_confirmation)
  end
end
