require "rails_helper"

RSpec.feature "Select Best Answer", type: :feature do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:another_user) { create(:user) }
  let!(:answer) { create(:answer, question: question, user: another_user) }

  scenario "User selects a best answer of his question" do
    sign_in user

    expect(question.answers).to include answer

    visit question_path(question)
    click_link "mark-best-answer"

    expect(page).to have_selector ".best-answer"
  end
end
