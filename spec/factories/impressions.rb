FactoryGirl.define do
  factory :impression do
    user_id 1
    question_id 1
    remote_ip { Faker::Internet.ip_v4_address }
    user_agent { Faker::Internet.user_agent }
    question
  end
end
