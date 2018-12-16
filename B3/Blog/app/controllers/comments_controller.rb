class CommentsController < ApplicationController
  def create
    redirect_to new_session_path and return if session[:user_id].nil?
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    flash[:success] = '发表成功，留言开始审核，审核通过将显示在文章中，请耐心等待！'
    render 'posts/show'
  end

  def audit_success
    redirect_to new_sessions_admin_path and return if session[:admin_id].nil?
    @comment = Comment.find(params[:id])
    @comment.update(audit: 1)
    flash[:audit] = 'comment'
    redirect_to admins_path
  end

  def audit_failed
    redirect_to new_sessions_admin_path and return if session[:admin_id].nil?
    @comment = Comment.find(params[:id])
    @comment.update(audit: 2)
    flash[:audit] = 'comment'
    redirect_to admins_path
  end

  def destroy
    redirect_to new_session_path and return if session[:user_id].nil? && session[:admin_id].nil?
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    if @comment.user_id == session[:user_id] || @comment.post.user_id == session[:user_id] || session[:admin_id]
      flash[:notice] = '删除成功'
      @comment.destroy
    else
      flash[:notice] = '删除失败（您没有权限）！'
    end
    if session[:position_comment] == 'admin_comment'
      redirect_to '/admins/show_comments'
    elsif session[:position_comment] == 'user_comment'
      redirect_to '/users/show_comments'
    elsif session[:position_comment] == 'post_admin_comment'
      redirect_to post_show_admin_path(@post)
    else
      redirect_to post_path(@post)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :user_id, :audit)
  end
end
