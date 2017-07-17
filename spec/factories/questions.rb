FactoryGirl.define do
  factory :question do
    title 'Title'
    body { Faker::Lorem.paragraph }
  end

  factory :invalid_question, class: "Question" do
    title ''
    body ''
  end
end
