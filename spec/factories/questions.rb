FactoryGirl.define do
  factory :question do
    title "Title"
    body { Faker::Lorem.paragraph }
    tag_list "windows,c++,c#,macosx,android-7.0"
    user

    factory :invalid_question do
      title ""
      body ""
    end
  end
end
