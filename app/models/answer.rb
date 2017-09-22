# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  question_id :integer
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  best        :boolean          default(FALSE)
#

class Answer < ApplicationRecord
  include Votable

  default_scope { order("best DESC, created_at DESC") }

  belongs_to :question, counter_cache: true
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments,
                                reject_if: proc { |attrs| attrs["file"].blank? && attrs["file_cache"].blank? }

  after_save :update_question_activity

  validates :body, presence: true, length: { in: 10..5000 }

  def mark_best!
    update(best: true) unless question.best_answer?
  end

  private

  def update_question_activity
    question.save
  end
end
