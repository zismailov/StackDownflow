class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_answer, except: :create
  before_action :answer_belongs_to_current_user?, only: [:edit, :update, :destroy]
  before_action :question_belongs_to_current_user?, only: [:mark_best]
  before_action :add_user_id_to_attachments, only: [:create, :update]
  after_action :publish_after_create, only: :create
  after_action :publish_after_destroy, only: :destroy
  after_action :add_answer_to_current_user, only: :create

  def create
    @comment = Comment.new
    respond_with @answer = @question.answers.create(answer_params)
  end

  def update
    respond_with @answer.update(answer_params) do |format|
      if @answer.valid?
        format.json { render json: @answer, status: 200 }
      else
        format.json { render json: @answer.errors, status: 422 }
      end
    end
  end

  def destroy
    respond_with @answer.destroy
  end

  def mark_best
    @answer.mark_best!
    flash[:success] = "Answer marked as best!"
    redirect_to @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :file_cache, :user_id])
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

  def add_user_id_to_attachments
    params[:answer][:attachments_attributes]&.each do |_k, v|
      v[:user_id] = current_user.id
    end
  end

  def publish_after_create
    if @answer.valid?
      PrivatePub.publish_to "/questions/#{@answer.question.id}",
                            answer_create: AnswerSerializer.new(@answer, root: false).to_json
    end
  end

  def publish_after_destroy
    PrivatePub.publish_to "/questions/#{@answer.question.id}", answer_destroy: @answer.id
  end

  def add_answer_to_current_user
    current_user.answers << @answer if @answer.valid?
  end
end
