FactoryGirl.define do
  factory :vote do
    vote 1
    association :votable
  end
end
