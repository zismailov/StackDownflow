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

  default_scope { order("best DESC, votes_sum DESC, created_at ASC") }

  belongs_to :question, counter_cache: true
  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :no_attachment

  validates :body, presence: true, length: { in: 10..5000 }

  after_save :update_question_activity
  after_create :send_notification

  def mark_best!
    return if question.best_answer?
    update(best: true)
    Reputation.add_to(user, :answer_mark_best)
  end

  private

  def update_question_activity
    question.save
  end

  def no_attachment(attrs)
    attrs["file"].blank? && attrs["file_cache"].blank?
  end

  def send_notification
    delay.notify_subscribers
    delay.notify_question_author
  end

  def notify_subscribers
    question.favorites.find_each do |user|
      AnswerMailer.new_for_subscribers(user, question).deliver
    end
  end

  def notify_question_author
    AnswerMailer.new_for_question_author(question.user, question).deliver
  end
end
