class Question < ApplicationRecord
  attr_accessor :tag_list

  before_save :add_tags_from_list

  has_many :answers
  belongs_to :user
  has_many :comments, as: :commentable
  has_and_belongs_to_many :tags

  validates :body, presence: true, length: { in: 10..5000 }
  validates :title, presence: true, length: { in: 5..512 }
  validates :tag_list, presence: true, tag_list: true

  def best_answer?
    answers.find_by(best: true) ? true : false
  end

  private

  def add_tags_from_list
    self.tags = Tag.create_from_list(tag_list.split(","))
  end
end
