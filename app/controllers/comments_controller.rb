class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_parent
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :comment_belongs_to_current_user?, only: [:edit, :update, :destroy]
  after_action :publish_after_destroy, only: [:destroy]
  after_action :publish_after_create, only: [:create]

  respond_to :json

  def create
    respond_with @comment = @parent.comments.create(comment_params.merge(user_id: current_user.id))
  end

  def update
    respond_with @comment.update(comment_params) do |format|
      if @comment.valid?
        format.json { render json: @comment, status: 200 }
      else
        format.json { render json: @comment.errors, status: 422 }
      end
    end
  end

  def destroy
    respond_with @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_belongs_to_current_user?
    redirect_to root_path, status: 403 unless @comment.user == current_user
  end

  # rubocop:disable LineLength
  # rubocop:disable Metrics/AbcSize
  def publish_after_destroy
    PrivatePub.publish_to "/questions/#{@comment.commentable.class.name == 'Question' ? @comment.commentable.id : @comment.commentable.question.id}",
                          comment_destroy: @comment.id, parent: @comment.commentable.class.name,
                          parent_id: @comment.commentable.id
  end

  def publish_after_create
    return unless @comment.valid?
    PrivatePub.publish_to "/questions/#{@parent.class.name == 'Question' ? @parent.id : @parent.question.id}",
                          comment_create: CommentSerializer.new(@comment, root: false).to_json,
                          parent: @parent.class.name,
                          parent_id: @parent.id
  end
end
