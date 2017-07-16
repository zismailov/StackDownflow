FactoryGirl.define do
  factory :question do
    title { FFaker::Lorem.word }
    body { FFaker::Lorem.paragraph }
  end
end
