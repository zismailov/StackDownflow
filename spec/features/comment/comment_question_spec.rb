require "rails_helper"

RSpec.feature "Questions Commenting", "
    In order to clarify something
    As an authenticated user
    I want to comment questions
  ", type: :feature do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:comment) { build(:question_comment, user: user, commentable: question) }

  scenario "User comments question" do
    post_comment comment.body

    within(".question") do
      expect(page).to have_content comment.body
    end
  end

  scenario "User comments question with invalid data" do
    post_comment ""

    expect(page).to have_content "Comment is not created!"
  end
end

def post_comment(comment)
  sign_in user
  visit question_path(question)

  within(".question") do
    click_on "Comment"
  end

  fill_in :comment_body, with: comment
  within(".question") do
    click_on "Post comment"
  end
end
