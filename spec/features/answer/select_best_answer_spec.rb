require "rails_helper"

RSpec.feature "Select Best Answer", type: :feature do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:question1) { create(:question, user: user1) }
  let(:question2) { create(:question, user: user2) }
  let!(:answer1) { create(:answer, question: question2, user: user1) }
  let!(:answer2) { create(:answer, question: question1, user: user2) }

  background do
    sign_in user2
  end

  scenario "User selects a best answer of his question" do
    visit question_path(question2)

    first(".answer").find(".mark-best-answer").click

    expect(page).to have_selector ".best-answer"
  end

  scenario "User can't select a best answer of other user's question" do
    visit question_path(question1)

    expect(page).not_to have_selector ".mark-best-answer"
  end
end
