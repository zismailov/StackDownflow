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

class AnswerSerializer < ApplicationSerializer
  include ActionView::Helpers::DateHelper

  attributes :id, :body, :created, :question, :edited, :files, :best, :votes_sum
  has_one :user
  has_many :comments

  def created
    time_ago_in_words(object.created_at)
  end

  def question
    question = object.question
    { id: question.id, title: question.title, body: question.body, best_answer: question.best_answer? }
  end

  def edited
    object.updated_at.to_s > object.created_at.to_s ? time_ago_in_words(object.updated_at) : false
  end

  def best
    object.best?
  end
end
