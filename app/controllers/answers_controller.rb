class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:edit, :update, :destroy, :mark_best]
  before_action :answer_belongs_to_current_user?, only: [:edit, :update, :destroy]
  before_action :question_belongs_to_current_user?, only: [:mark_best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:success] = "Answer is created!"
    else
      flash[:danger] = "Wrong length of answer!"
    end
    redirect_to @question
  end

  def edit; end

  def update
    if @answer.update(answer_params)
      flash[:success] = "Answer is updated!"
      redirect_to question_path(@answer.question)
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    flash[:success] = "Answer is deleted!"
    redirect_to root_path
  end

  def mark_best
    @answer.mark_best!
    flash[:success] = "Answer marked as best!"
    redirect_to @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_belongs_to_current_user?
    redirect_to root_path unless @answer.user == current_user
  end

  def question_belongs_to_current_user?
    redirect_to @answer.question unless @answer.question.user == current_user
  end
end
