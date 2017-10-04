# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  vote         :integer
#  votable_id   :integer
#  votable_type :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, presence: true
  validates :votable_id, presence: true
  validates :votable_type, presence: true
  validates :vote, presence: true

  after_destroy :decrement_parent_counter
  after_save :increment_parent_counter

  private

  def increment_parent_counter
    votable.increment(:votes_sum, vote).save
  end

  def decrement_parent_counter
    votable.decrement(:votes_sum, vote).save
  end
end
