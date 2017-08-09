class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :comment_belongs_to_current_user?, only: [:edit, :update, :destroy]

  def create
    @comment = @parent.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      flash.now[:success] = "Comment is created!"
      render json: @comment, status: 201, root: false
    else
      flash.now[:danger] = "Invalid data! Comment length should be more than 10 symbols!"
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    update_resource @comment
  end

  def destroy
    destroy_resource @comment
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_belongs_to_current_user?
    redirect_to root_path, status: 403 unless @comment.user == current_user
  end
end
