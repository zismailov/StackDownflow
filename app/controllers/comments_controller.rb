class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :comment_belongs_to_current_user?, only: [:edit, :update, :destroy]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      flash.now[:success] = "Comment is created!"
    else
      flash.now[:danger] = "Invalid data! Comment length should be more than 10 symbols!"
    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to @return_path, success: "Comment is edited!"
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    flash.now[:success] = "Comment is deleted!"
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
    redirect_to @return_path unless @comment.user == current_user
  end
end
