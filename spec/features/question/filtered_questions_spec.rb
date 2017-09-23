require "rails_helper"

RSpec.feature "Filtered Questions", type: :feature do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:questions) { create_list(:question, 3, tag_list: "filtering", user: user2) }
  let(:answer) { build(:answer, question: questions[1]) }
  let(:answer_comment) { build(:answer_comment, commentable: answer) }
  let(:question_comment) { build(:question_comment, commentable: questions[0]) }

  background do
    sign_in user
    # questions[0].vote_up(user)
  end

  scenario "User visits index page and sees questions with newest on top" do
    visit root_path
    expect(page).to have_selector "#question_#{questions[2].id} +
                                   #question_#{questions[1].id} +
                                   #question_#{questions[0].id}"
  end

  scenario "User visits page with questions sorted by votes and sees questions with descending sorting" do
    questions[0].vote_up(user)
    visit root_path
    within(".questions-sorting") do
      click_link "popular"
    end

    expect(page).to have_selector "#question_#{questions[0].id} +
                                   #question_#{questions[2].id} +
                                   #question_#{questions[1].id}"
  end

  scenario "User can view a list of unanswered questions" do
    answer.save
    visit root_path
    within(".questions-sorting") do
      click_link "unanswered"
    end

    expect(page).to have_selector "#question_#{questions[2].id} + #question_#{questions[0].id}"
  end

  scenario "User can view a list of questions sorted by recent activity" do
    visit root_path
    within(".questions-sorting") do
      click_link "active"
    end
    expect(page).to have_selector "#question_#{questions[2].id} +
                                   #question_#{questions[1].id} +
                                   #question_#{questions[0].id}"

    answer.save
    visit active_questions_path
    expect(page).to have_selector "#question_#{questions[1].id} +
                                   #question_#{questions[2].id} +
                                   #question_#{questions[0].id}"

    question_comment.save
    visit active_questions_path
    expect(page).to have_selector "#question_#{questions[0].id} +
                                   #question_#{questions[1].id} +
                                   #question_#{questions[2].id}"

    answer_comment.save
    visit active_questions_path
    expect(page).to have_selector "#question_#{questions[1].id} +
                                   #question_#{questions[0].id} +
                                   #question_#{questions[2].id}"

    question_comment.update(body: "When I thought that fought this war alone")
    visit active_questions_path
    expect(page).to have_selector "#question_#{questions[0].id} +
                                   #question_#{questions[1].id} +
                                   #question_#{questions[2].id}"

    questions[2].update(body: "You were there by my side on the frontline")
    visit active_questions_path
    expect(page).to have_selector "#question_#{questions[2].id} +
                                   #question_#{questions[0].id} +
                                   #question_#{questions[1].id}"

    answer_comment.update(body: "And we fought to believe the impossible")
    visit active_questions_path
    expect(page).to have_selector "#question_#{questions[1].id} +
                                   #question_#{questions[2].id} +
                                   #question_#{questions[0].id}"
  end
end
