FactoryGirl.define do
  factory :question do
    title "Title"
    body { Faker::Lorem.paragraph }

    factory :invalid_question do
      title ""
      body ""
    end
  end
end
