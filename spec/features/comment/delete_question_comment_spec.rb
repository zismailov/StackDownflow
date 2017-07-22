require "rails_helper"

RSpec.feature "Delete Question Comment", type: :feature do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:comment) { create(:question_comment, user: user, commentable: question) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario "User deletes his question comment" do
    within(".comment[data-comment-id='#{comment.id}']") do
      click_on "delete"
    end

    expect(page).not_to have_content comment.body
  end
end
