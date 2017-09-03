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

FactoryGirl.define do
  factory :question do
    title "Title"
    body { Faker::Lorem.paragraph }
    tag_list "windows,c++,c#,macosx,android-7.0"
    user

    factory :invalid_question do
      title ""
      body ""
    end
  end
end
