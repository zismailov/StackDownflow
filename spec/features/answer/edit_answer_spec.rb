require "rails_helper"

RSpec.feature "Edit Answer", type: :feature do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question) }

  scenario "User edits his answer" do
    sign_in user

    expect(question.answers).to include answer

    visit question_path(question)
    click_link "edit-answer"

    expect(page).to have_content answer.body

    fill_in "answer_body", with: answer.body.reverse
    click_button "Edit"

    expect(page).to have_content answer.body.reverse
  end
end
