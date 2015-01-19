class CommentsController < ApplicationController
  def create
    comment = Comment.new(comment_params)
    if comment.save
      render json: comment
    else
      render json: comment.errors.full_messages, status: :unprocessable_entity
    end

  end

  def delete
    comment = Comment.find(params[:id])
    if comment
      comment.destroy
      render json: comment
    else
      render status: :not_found
    end
  end

  def update
    comment = Comment.find(params[:id])
    if comment
      comment.update(comment_params)
      render json: comment
    else
      render status: :not_found
    end
  end

  private
  
  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type)
  end

end
