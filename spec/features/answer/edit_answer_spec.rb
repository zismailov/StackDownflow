require "rails_helper"

RSpec.feature "Edit Answer", type: :feature do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user1) }
  let!(:answer1) { create(:answer, user: user1, question: question) }
  let!(:answer2) { create(:answer, user: user2, question: question) }

  background do
    sign_in user2
    visit question_path(question)
  end

  scenario "User edits his answer" do
    within ".answer[data-answer-id='#{answer2.id}']" do
      click_link "edit-answer"
    end
    expect(page).to have_content answer2.body

    fill_in "answer_body", with: answer2.body.reverse
    click_button "Update"

    expect(page).to have_content answer2.body.reverse
  end

  scenario "User can't edit not his answer" do
    within ".answer[data-answer-id='#{answer1.id}']" do
      expect(page).not_to have_selector "edit-answer"
    end
  end
end
