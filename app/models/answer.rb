class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :comments, as: :commentable

  validates :body, presence: true, length: { in: 10..5000 }

  def mark_best!
    update(best: true) unless question.best_answer?
  end
end
