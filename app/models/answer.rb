class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates :body, length: { in: 10..5000 }

  def mark_best!
    update(best: true)
  end

  def unmark_best!
    update(best: false)
  end
end
