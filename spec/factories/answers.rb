FactoryGirl.define do
  factory :answer do
    body { Faker::Lorem.paragraph }
  end
end
