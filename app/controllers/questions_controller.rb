class QuestionsController < ApplicationController
  before_action :must_be_logged_in, only: %i[new create]

  def index
    @questions = Question.all.order("created_at DESC")
  end

  def new
    @question = Question.new
  end

  def show
    @question = Question.find(params[:id])
    @answers = @question.answers
    @answer = Answer.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      flash[:success] = "Question is created!"
      redirect_to @question
    else
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def must_be_logged_in
    return if user_signed_in?
    flash[:danger] = "You need to log in to ask questions."
    redirect_to root_path
  end
end
