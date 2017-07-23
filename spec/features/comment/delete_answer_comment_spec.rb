require "rails_helper"

RSpec.feature "Delete Answer Comment", type: :feature do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question) }
  let!(:comment) { create(:answer_comment, user: user, commentable: answer) }
  let!(:comment2) { create(:answer_comment, user: user2, commentable: answer) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario "User deletes his answer comment" do
    within(".answer[data-answer-id='#{answer.id}'] .comment[data-comment-id='#{comment.id}']") do
      click_on "delete"
    end

    expect(page).not_to have_selector ".answers .content[data-comment-id='#{comment.id}']"
  end

  scenario "User can't delete not his answer comment" do
    within(".answer[data-answer-id='#{answer.id}'] .comment[data-comment-id='#{comment2.id}']") do
      expect(page).not_to have_content "delete"
    end
  end
end
