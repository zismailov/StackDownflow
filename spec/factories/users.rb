FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "User#{n}" }
    email { Faker::Internet.email }
    password { SecureRandom.hex(8) }
  end
end
