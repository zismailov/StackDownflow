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
require_relative "helpers/files"

class QuestionSerializer < ActiveModel::Serializer
  include FilesSerializerHelper

  attributes :id, :title, :body, :answers, :files, :tags, :list_of_tags

  def answers
    object.answers.each { |answer| { id: answer.id, body: answer.body, author: answer.user.username } }
  end

  def tags
    object.tags.map(&:name)
  end

  def list_of_tags
    object.tags.map(&:name).join(",")
  end
end
