FactoryGirl.define do
  factory :vote do
    user_id 1
    vote 1
    votable_id 1
    votable_type "MyString"
  end
end
