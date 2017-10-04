# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

100.times do
  user = {}
  user["full_name"] = Faker::Name.name
  user["username"] = user["full_name"].parameterize.underscore
  user["email"] = user["username"] + "@email.com"
  user["password"] = "123123"
  user["password_confirmation"] = "123123"
  user["age"] = rand(100)+1
  user["location"] = Faker::Address.country
  user["website"] = Faker::Internet.domain_name

  new_user = User.new(user)
  new_user.skip_confirmation!
  new_user.regular!
  new_user.save!
end

users_count = User.count
50.times do
  user_id = rand(users_count)+1
  user = User.find(user_id)
  user.questions.create(title: Faker::Lorem.sentence, body: Faker::Lorem.sentence(10, false, 10), tag_list: Faker::Lorem.words(rand(5)+1).join(","))
end

Question.find_each do |question|
  (rand(5)+1).times do
    answer = question.answers.create(body: Faker::Lorem.sentence(4, false, 4), user_id: rand(users_count)+1)
    question.comments.create(body: Faker::Lorem.sentence(4, false, 4), user_id: rand(users_count)+1)
    (rand(5)+1).times do
      answer.comments.create(body: Faker::Lorem.sentence(4, false, 4), user_id: rand(users_count)+1)
    end
  end
end

1000.times do
  model = [Question, Answer, Comment].sample
  user = rand(users_count)+1
  rand_record = model.where(id: rand(model.count)+1).first
  unless rand_record.user.id == user
    rand_record.votes.create(vote: [1, -1].sample, user_id: user)
  end
end

question_count = Question.count
30.times do
  question = Question.where(id: rand(question_count)+1).first
  unless question.has_best_answer?
    answers = question.answers
    answer = answers.where(id: question.answer_ids.sample).first
    unless answer.best?
      answer.mark_best!
    end
  end
end

10.times do
  user_id = rand(users_count)+1
  user = User.find(user_id)
  user.questions.create(title: Faker::Lorem.sentence, body: Faker::Lorem.sentence(10, false, 10), tag_list: Faker::Lorem.words(rand(5)+1).join(","))
end
