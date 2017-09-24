require "rails_helper"

RSpec.feature "Select Best Answer", type: :feature do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:question1) { create(:question, user: user1) }
  let(:question2) { create(:question, user: user2) }
  let!(:answer1) { create(:answer, question: question2, user: user1) }
  let!(:answer2) { create(:answer, question: question2, user: user1) }
  let!(:answer3) { create(:answer, question: question1, user: user2) }

  background do
    sign_in user2
  end

  scenario "User selects a best answer for his question" do
    select_best_answer question2, answer1.id

    expect(page).to have_selector ".best-answer", text: answer1.body
    expect(page).to have_content "marked as best"
  end

  scenario "User can't select a best answer for another user's question" do
    visit question_path(question1)

    expect(page).not_to have_selector ".mark-best-answer"
  end

  scenario "User can select only one best answer" do
    select_best_answer question2, answer1.id

    expect(page).not_to have_selector ".mark-best-answer"
  end
end

def select_best_answer(question, answer_id)
  visit question_path(question)
  find(".answers #answer_#{answer_id} .mark-best-answer").click
end
