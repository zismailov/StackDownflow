FactoryGirl.define do
  factory :answer do
    body { Faker::Lorem.paragraph }
    question

    factory :invalid_answer do
      body ""
      question
    end
  end
end
