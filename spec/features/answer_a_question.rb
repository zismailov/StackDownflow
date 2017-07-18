require "rails_helper"

# Feature: 'Answer a Question'
#  In order help other people
#  As an authenticated user with a lot of spare time
#  I want to have an ability to answer other user's questions

RSpec.feature "Answer a Question", type: :feature do
  let!(:inquirer) { create(:user) }
  let!(:question) { create(:question, user: inquirer) }
  let!(:answerer) { create(:user) }
  let!(:answer) { build(:answer, question: question, user: answerer) }

  scenario "Authenticated user answers another user's question" do
    sign_in answerer

    visit question_path(question)
    # save_and_open_page
    fill_in :answer_body, with: answer.body
    click_on "Answer"

    expect(page).to have_content answer.body
    expect(page).to have_content answer.user.username
  end

  private

  def sign_in(user)
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end
end
