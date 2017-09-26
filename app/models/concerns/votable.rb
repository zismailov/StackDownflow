module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(voter)
    unless voted_by? voter
      votes.create(user_id: voter.id, vote: 1)

      if self.class.name == "Question"
        user.increment(:reputation, 5).save!
      elsif self.class.name == "Answer"
        user.increment(:reputation, 10).save!
      end
    end
  end

  def vote_down(voter)
    votes.create(user_id: voter.id, vote: -1) unless voted_by? voter
  end

  def voted_by?(voter)
    votes.find_by_user_id(voter) ? true : false
  end

  def user_voted(voter)
    votes.find_by_user_id(voter).vote if voted_by?(voter)
  end
end
