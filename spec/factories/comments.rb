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

FactoryGirl.define do
  factory :question_comment, class: "Comment" do
    body "This is a question comment, yo!"
    association :commentable
    user
  end

  factory :answer_comment, class: "Comment" do
    body "This is an answer comment, yo!"
    association :commentable
    user
  end
end
