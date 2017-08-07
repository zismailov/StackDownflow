class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_votable
  before_action :votable_doesnt_belong_to_current_user?

  respond_to :json

  def vote_up
    @votable.vote_up current_user
    render json: { votes: @votable.votes }, status: 200
  end

  def vote_down
    @votable.vote_down current_user
    render json: { votes: @votable.votes }, status: 200
  end

  private

  # rubocop:disable Metrics/AbcSize
  def set_votable
    if !params[:answer_id].nil?
      @votable = Answer.find(params[:answer_id])
      @return_path = @votable.question
    elsif !params[:question_id].nil?
      @votable = Question.find(params[:question_id])
      @return_path = @votable
    end
  end

  def votable_doesnt_belong_to_current_user?
    respond_with nil, status: 501, location: nil if @votable.user == current_user
  end
end