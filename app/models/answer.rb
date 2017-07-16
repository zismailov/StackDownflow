class Answer < ApplicationRecord
  belongs_to :question

  validates :body, presence: true
  validates :body, length: { in: 10..5000 }
end
