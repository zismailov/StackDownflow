# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  votes      :integer          default(0), not null
#

class QuestionSerializer < ApplicationSerializer
  attributes :id, :title, :body, :answers, :files, :tags, :list_of_tags, :best_answer

  def answers
    object.answers.each { |answer| { id: answer.id, body: answer.body, author: answer.user.username } }
  end

  def tags
    object.tags.map(&:name)
  end

  def list_of_tags
    object.tag_list
  end

  def best_answer
    object.best_answer?
  end
end
