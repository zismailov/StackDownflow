class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_parent

  def vote_up
    authorize! :vote_up, @parent
    @parent.vote_up current_user
    publish_and_return_votes
  end

  def vote_down
    authorize! :vote_down, @parent
    @parent.vote_down current_user
    publish_and_return_votes
  end

  private

  # rubocop:disable LineLength
  # rubocop:disable Metrics/AbcSize
  def publish_and_return_votes
    @parent.reload
    question_id = case @parent.class.name
                  when "Question" then @parent.id
                  when "Answer" then @parent.question.id
                  when "Comment" then @parent.commentable.class.name == "Question" ? @parent.commentable.id : @parent.commentable.question.id
                  end

    unless Rails.env.production?
      PrivatePub.publish_to "/questions/#{question_id}", vote: @parent.votes_sum, parent: @parent.class.name, parent_id: @parent.id
    end
    render json: { votes: @parent.votes_sum }, status: 200
  end
end
