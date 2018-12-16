class SessionsAdminController < ApplicationController
  def new
    redirect_to admins_path and return unless session[:admin_id].nil?
  end

  def create
    redirect_to admins_path and return unless session[:admin_id].nil?
    @temp_admin = Admin.find_by_username(params[:username])
    if @temp_admin
      @admin = @temp_admin.authenticate(params[:password])
      if @admin
        session[:admin_id] = @admin.id
        redirect_to admins_path
      else
        flash[:notice] = '管理员用户名或者密码不正确'
        render 'new'
      end
    else
      flash[:notice] = '管理员用户名或者密码不正确'
      render 'new'
    end
  end

  def destroy
    redirect_to new_sessions_admin_path and return if session[:admin_id].nil?
    session[:admin_id] = nil
    flash[:notice] = '退出登陆成功'
    redirect_to new_sessions_admin_path
  end
end
