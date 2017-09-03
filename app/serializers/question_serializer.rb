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

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :answers, :files, :tags, :list_of_tags

  def answers
    object.answers.each { |answer| { id: answer.id, body: answer.body, author: answer.user.username } }
  end

  def files
    object.attachments.map { |a| { path: a.file.file, filename: a.file.file.filename } }
  end

  def tags
    object.tags.map(&:name)
  end

  def list_of_tags
    object.tags.map(&:name).join(",")
  end
end
