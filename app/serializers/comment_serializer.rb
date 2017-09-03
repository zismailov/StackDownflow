# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  body             :text
#  commentable_id   :integer
#  commentable_type :string
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class CommentSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper
  attributes :id, :body, :user, :commentable, :author, :commentable_id, :created, :edited, :total_votes

  def commentable
    object.commentable_type.downcase.pluralize
  end

  def author
    object.user.username
  end

  def created
    time_ago_in_words(object.created_at)
  end

  def edited
    object.updated_at.to_s > object.created_at.to_s ? time_ago_in_words(object.updated_at) : false
  end
end
