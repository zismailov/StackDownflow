require "rails_helper"

RSpec.feature "Answer Commenting", "
  In order to clarify something
  As an authenticated user
  I want to comment answers
", type: :feature do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }
  let(:comment) { build(:answer_comment, user: user, commentable: answer) }

  scenario "User comments answer" do
    post_comment comment.body

    within(".answer") do
      expect(page).to have_content comment.body
    end
  end

  scenario "User comments answer with invalid data" do
    post_comment ""

    expect(page).to have_content "Ivalid data!"
  end
end

def post_comment(comment)
  sign_in user
  visit question_path(question)

  within(".answer") do
    click_on "Comment"
  end

  fill_in :comment_body, with: comment
  within(".answer") do
    click_on "Post comment"
  end
end
