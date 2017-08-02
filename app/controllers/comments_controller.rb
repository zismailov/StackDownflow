class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :comment_belongs_to_current_user?, only: [:edit, :update, :destroy]

  respond_to :json, only: [:create, :update, :destroy]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      flash.now[:success] = "Comment is created!"
      respond_with @comment, location: nil, root: false
    else
      flash.now[:danger] = "Invalid data! Comment length should be more than 10 symbols!"
      respond_with(@comment.errors.as_json, status: :unprocessable_entity, location: nil)
    end
  end

  def update
    if @comment.update(comment_params)
      flash.now[:success] = "Comment is edited!"
      render json: @comment, root: false
    else
      flash.now[:danger] = "Comment is not edited! See errors below."
      render json: @comment.errors.as_json, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    flash.now[:success] = "Comment is deleted!"
    respond_with :nothing, status: 204
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  # rubocop:disable Metrics/AbcSize
  def set_commentable
    if !params[:answer_id].nil?
      @commentable = Answer.find(params[:answer_id])
      @return_path = @commentable.question
    elsif !params[:question_id].nil?
      puts "$$$$ Question #{Question.count}"
      puts "$$$$ Question #{Question.first.inspect}"
      @commentable = Question.find(params[:question_id])
      @return_path = @commentable
    end
  end

  def set_comment
    puts "$$$$ Comment #{Comment.count}"
    @comment = @commentable.comments.find(params[:id])
  end

  def comment_belongs_to_current_user?
    redirect_to root_path, status: 403 unless @comment.user == current_user
  end
end
