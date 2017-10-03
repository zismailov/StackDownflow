class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_answer, except: :create
  before_action :add_user_id_to_attachments, only: [:create, :update]
  after_action :publish, only: [:create, :destroy], unless: -> { Rails.env.production? }

  respond_to :json

  authorize_resource

  def create
    @comment = Comment.new
    respond_with @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
  end

  def update
    update_resource @answer
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

  def publish
    case params[:action]
    when "create"
      if @answer.valid?
        PrivatePub.publish_to "/questions/#{@answer.question.id}",
                              answer_create: AnswerSerializer.new(@answer, root: false).to_json
      end
    when "destroy"
      PrivatePub.publish_to "/questions/#{@answer.question.id}", answer_destroy: @answer.id
    end
  end
end
