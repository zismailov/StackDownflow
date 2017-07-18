class AnswersController < ApplicationController
  before_action :must_be_logged_in, except: [:show]
  before_action :set_answer, only: [:edit, :update, :mark_best]
  before_action :set_question, only: [:create, :show]

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

  def show
    @answers = @question.answers
    @answer = Answer.new
    render "questions#show"
  end

  def edit; end

  def update
    if @answer.update(answer_params)
      flash[:success] = "Answer is updated!"
      redirect_to question_path(@answer.question.id)
    else
      render :edit
    end
  end

  def destroy
    @answer = current_user.answers.find(params[:id])
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

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def must_be_logged_in
    return if user_signed_in?
    flash[:danger] = "You must be logged in."
    redirect_to root_path
  end
end
