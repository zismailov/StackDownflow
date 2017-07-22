class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :set_comment, only: [:edit, :update]
  before_action :comment_belongs_to_current_user?, only: [:edit, :update]

  def create
    @comment = @question.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:success] = "Comment is created!"
    else
      flash[:danger] = "Comment is not created!"
    end
    redirect_to question_path(@question)
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to question_path(@question), success: "Comment is edited!"
    else
      render :edit
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_comment
    @comment = @question.comments.find(params[:id])
  end

  def comment_belongs_to_current_user?
    redirect_to question_path(@question) unless @comment.user == current_user
  end
end
