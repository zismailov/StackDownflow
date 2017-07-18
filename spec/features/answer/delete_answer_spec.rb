require "rails_helper"

RSpec.feature "Delete Answer", type: :feature do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question) }

  scenario "User deletes his anwer" do
    sign_in user

    expect(question.answers).to include answer

    visit question_path(question)
    click_link "delete-answer"

    expect(page).to have_selector ".alert-success"
    expect(page).not_to have_content answer.body
  end
end
