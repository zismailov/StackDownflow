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
