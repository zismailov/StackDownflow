require "rails_helper"

# Feature: 'Answer a Question'
#  In order to help other people
#  As an authenticated user with a lot of spare time
#  I want to have an ability to answer other users' questions, edit, and delete my answers

RSpec.feature "Answer a Question", type: :feature do
  let!(:inquirer) { create(:user) }
  let!(:question) { create(:question, user: inquirer) }
  let!(:answerer) { create(:user) }
  let!(:answer) { build(:answer, question: question, user: answerer) }

  background do
    sign_in answerer
    visit question_path(question)
  end

  scenario "Authenticated user answers another user's question" do
    fill_in :answer_body, with: answer.body
    click_on "Answer"

    expect(page).to have_content answer.body
    expect(page).to have_content answer.user.username
  end

  scenario "Authenticated user answers another user's question without filling a required field" do
    click_on "Answer"

    expect(page).to have_selector ".alert-danger"
  end
end
