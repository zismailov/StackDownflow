FactoryGirl.define do
  factory :comment do
    body "MyTextString"
    commentable_id 1
    commentable_type "Question"

    factory :invalid_comment do
      body ""
    end
  end
end
