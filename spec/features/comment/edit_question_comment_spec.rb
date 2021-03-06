require "rails_helper"

RSpec.feature "Edit Question Comment", type: :feature do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:question_comment) { create(:question_comment, user: user, commentable: question) }
  let!(:question_comment2) { create(:question_comment, user: user2, commentable: question) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario "User edits his question comment", js: true do
    edit_comment_with question_comment.body.reverse

    within(".question .comments") do
      expect(page).to have_content question_comment.body.reverse
    end
  end

  scenario "User edits his question comment with valid data", js: true do
    edit_comment_with ""

    expect(page).to have_content "problems"
  end

  scenario "User can't edit not his comment", js: true do
    within(".question #comment_#{question_comment2.id}") do
      expect(page).not_to have_selector "edit"
    end
  end
end

def edit_comment_with(new_comment_body)
  within(".question #comment_#{question_comment.id}") do
    click_link "edit"
  end

  within(".question .comments") do
    expect(page).to have_selector "textarea"
    fill_in "comment_body", with: new_comment_body
    click_on "Update Comment"
  end
end
