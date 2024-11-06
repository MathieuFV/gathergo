class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_back(fallback_location: root_path, notice: 'Comment added!')
    else
      redirect_back(fallback_location: root_path, alert: 'Error adding comment')
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :commentable_type, :commentable_id)
  end
end
