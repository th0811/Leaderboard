class CommentsController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    @comment = current_user.comments.new(comment_params)
    @comment.game_id = params[:game_id]
    if @comment.save
      flash[:success] = 'コメントを投稿しました'
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = 'コメントの投稿に失敗しました' + @comment.errors.full_messages.join(',')
      redirect_back(fallback_location: root_path)
    end

  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
