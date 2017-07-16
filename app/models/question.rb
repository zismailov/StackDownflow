class Question < ApplicationRecord
  has_many :answers

  validates :title, :body, presence: true
  validates :body, length: { in: 10..5000 }
  validates :title, length: { in: 5..512 }
end
