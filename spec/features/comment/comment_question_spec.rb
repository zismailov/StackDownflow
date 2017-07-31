require "rails_helper"

RSpec.feature "Questions Commenting", "
    In order to clarify something
    As an authenticated user
    I want to comment questions
  ", type: :feature do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:comment) { build(:question_comment, user: user, commentable: question) }

  scenario "User comments question", js: true do
    post_comment comment.body

    within(".question") do
      expect(page).to have_content comment.body
    end
  end

  scenario "User comments question with invalid data", js: true do
    post_comment ""

    within(".question") do
      expect(page).to have_content "problems"
    end
  end
end

def post_comment(comment)
  sign_in user
  visit question_path(question)

  within(".question") do
    click_on "Comment"
    fill_in :comment_body, with: comment
    click_on "Create Comment"
  end
end
