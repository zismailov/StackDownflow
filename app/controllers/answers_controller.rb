class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_answer, except: :create
  before_action :answer_belongs_to_current_user?, only: [:edit, :update, :destroy]
  before_action :question_belongs_to_current_user?, only: [:mark_best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @comment = Comment.new
    if @answer.save
      flash.now[:success] = "Answer is created!"
      PrivatePub.publish_to "/questions/#{@answer.question.id}",
                            answer_create: AnswerSerializer.new(@answer, root: false).to_json
      render json: @answer, root: false, status: 201
    else
      flash.now[:danger] = "Answer is not created! See errors below."
      render json: @answer.errors.as_json, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      flash.now[:success] = "Answer is updated!"
      render json: @answer, root: false, status: 200
    else
      flash.now[:danger] = "Answer is not updated! See errors below."
      render json: @answer.errors.as_json, status: :unprocessable_entity
    end
  end

  def destroy
    @answer_id = @answer.id
    @answer.destroy
    flash.now[:success] = "Answer is deleted!"
    PrivatePub.publish_to "/questions/#{@answer.question.id}", answer_destroy: @answer.id
    render json: :nothing, status: 204
  end

  def mark_best
    @answer.mark_best!
    flash[:success] = "Answer marked as best!"
    redirect_to @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_belongs_to_current_user?
    redirect_to @answer.question unless @answer.user == current_user
  end

  def question_belongs_to_current_user?
    redirect_to @answer.question unless @answer.question.user == current_user
  end
end
