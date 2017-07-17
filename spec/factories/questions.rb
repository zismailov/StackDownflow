FactoryGirl.define do
  factory :question do
    title "Title"
    body { Faker::Lorem.paragraph }
    user

    factory :invalid_question do
      title ""
      body ""
    end
  end
end
