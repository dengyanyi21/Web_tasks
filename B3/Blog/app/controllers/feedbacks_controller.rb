class FeedbacksController < ApplicationController
  def new
    redirect_to new_session_path and return if session[:user_id].nil?
    @feedback = Feedback.new
  end

  def create
    redirect_to new_session_path and return if session[:user_id].nil?
    @feedback = Feedback.new(feedback_params)

    if @feedback.save
      flash[:success] = '反馈已提交，感谢您的反馈！'
      @feedback = Feedback.new
    else
      flash[:failed] = '反馈提交失败，存在以下错误！'
    end
    render 'new'
  end

  private

  def feedback_params
    params.require(:feedback).permit(:content, :user_id)
  end
end
