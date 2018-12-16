class PostsController < ApplicationController
  def index
    redirect_to new_session_path and return if session[:user_id].nil?
    @posts = Post.where(audit: 1).order(created_at: :desc).page(params[:page]).per(5)
  end

  def show
    redirect_to new_session_path and return if session[:user_id].nil?
    @post = Post.find(params[:id])
  end

  def show_admin
    redirect_to new_sessions_admin_path and return if session[:admin_id].nil?
    @post = Post.find(params[:id])
  end

  def new
    redirect_to new_session_path and return if session[:user_id].nil?
    @post = Post.new
  end

  def edit
    redirect_to new_session_path and return if session[:user_id].nil?
    @post = Post.find(params[:id])
  end

  def create
    redirect_to new_session_path and return if session[:user_id].nil?
    @post = Post.new(post_params)
    if @post.save
      @post = Post.new
      flash[:success] = '提交成功。文章开始审核，审核通过将显示在博客首页中，请耐心等待！'
    else
      flash[:failed] = '提交失败，存在以下错误！'
    end
    render 'new'
  end

  def update
    redirect_to new_session_path and return if session[:user_id].nil?
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:success] = '文章修改成功！'
    else
      flash[:failed] = '提交失败，存在以下错误！'
    end
    render 'edit'
  end

  def audit_success
    redirect_to new_sessions_admin_path and return if session[:admin_id].nil?
    @post = Post.find(params[:id])
    @post.update(audit: 1)
    flash[:audit] = 'post'
    redirect_to admins_path
  end

  def audit_failed
    redirect_to new_sessions_admin_path and return if session[:admin_id].nil?
    @post = Post.find(params[:id])
    @post.update(audit: 2)
    flash[:audit] = 'post'
    redirect_to admins_path
  end

  def destroy
    redirect_to new_session_path and return if session[:user_id].nil? && session[:admin_id].nil?
    flash[:link] = flash[:position]
    @post = Post.find(params[:id])
    if @post.user_id == session[:user_id] || session[:admin_id]
      flash[:notice] = '删除成功'
      @post.destroy
    else
      flash[:notice] = '删除失败（您没有权限）！'
    end
    if session[:position] == 'profile'
      redirect_to user_path(session[:user_id])
    else
      redirect_to admin_path(session[:admin_id])
    end
  end

  def result_date
    redirect_to new_session_path and return if session[:user_id].nil?
    temp_date = Date.civil(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i)
    @posts = Post.where("date(created_at) = ? and audit = 1", temp_date.to_s).order(created_at: :desc).page(params[:page]).per(5)
    if @posts.size.zero?
      flash[:notice_date] = '该日期不存在文章'
      redirect_to posts_path
    else
      @date = temp_date
    end
  end

  def result_category
    redirect_to new_session_path and return if session[:user_id].nil?
    temp_category = params[:category]
    @posts = Post.where(category: temp_category, audit: 1).order(created_at: :desc).page(params[:page]).per(5)
    if @posts.size.zero?
      flash[:notice_category] = '该分类不存在文章'
      redirect_to posts_path
    else
      @category = temp_category
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :category, :user_id, :audit)
  end
end
