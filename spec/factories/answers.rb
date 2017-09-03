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

FactoryGirl.define do
  factory :answer do
    body { Faker::Lorem.paragraph }
    best false
    question
    user

    factory :invalid_answer do
      body ""
    end
  end
end
