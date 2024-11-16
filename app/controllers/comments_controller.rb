class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @commentable = @comment.commentable  # Récupère l'objet commentable (Destination dans ce cas)

    respond_to do |format|
      if @comment.save
        comment_html = render_to_string(partial: 'shared/comment', locals: { comment: @comment })
        format.json { render json: { html: comment_html, status: :created } }
      else
        format.json { render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :commentable_type, :commentable_id)
  end
end
