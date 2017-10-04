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

class Comment < ApplicationRecord
  include Votable

  default_scope { order("created_at") }

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true, length: { in: 10..5000 }

  after_save :update_question_activity

  private

  def update_question_activity
    commentable.class.name == "Question" ? commentable.save : commentable.question.save
  end
end
