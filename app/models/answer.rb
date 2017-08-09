class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments

  validates :body, presence: true, length: { in: 10..5000 }

  def mark_best!
    update(best: true) unless question.best_answer?
  end
end
