class CommentsController < ApplicationController
  before_action :authenticate_user
  before_action :set_comment, only: [:update, :destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.post_id = params[:post_id]
    if @comment.save
      render json: @comment, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @comment.user == current_user && @comment.update(comment_params)
      render json: @comment
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @comment.user == current_user
      @comment.destroy
      head :no_content
    else
      render json: { errors: ['Not authorized'] }, status: :unauthorized
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
