class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new, :update, :destroy]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :question_belongs_to_current_user?, only: [:edit, :update, :destroy]

  respond_to :html, except: [:update]
  respond_to :json, only: [:update]

  has_scope :popular, type: :boolean, allow_blank: true
  has_scope :unanswered, type: :boolean, allow_blank: true
  has_scope :active, type: :boolean, allow_blank: true
  has_scope :tagged_with, as: :tag

  def index
    respond_with @questions = apply_scopes(Question).all
  end

  def new
    @question = Question.new
    @attachment = @question.attachments.build
  end

  def show
    @answers = @question.answers
    @comments = @question.comments
    @question.impressions.find_or_create_by(remote_ip: request.remote_ip,
                                            user_agent: (request.user_agent || "no user_agent"))
  end

  def create
    respond_with @question = current_user.questions.create(question_params)
  end

  def update
    update_resource @question
  end

  def destroy
    respond_with @question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, :tag_list,
                                     attachments_attributes: [:file, :file_cache, :user_id, :_destroy])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_belongs_to_current_user?
    redirect_to root_path unless @question.user == current_user
  end
end
