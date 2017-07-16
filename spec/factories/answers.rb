FactoryGirl.define do
  factory :answer do
    body { FFaker::Lorem.paragraph }
  end
end
