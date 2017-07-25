require "rails_helper"

RSpec.feature "Delete Question Comment", type: :feature do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:comment) { create(:question_comment, user: user, commentable: question) }
  let!(:comment2) { create(:question_comment, user: user2, commentable: question) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario "User deletes his question comment", js: true do
    within(".comment[data-comment-id='#{comment.id}']") do
      click_on "delete"
    end
    page.driver.browser.switch_to.alert.accept

    expect(page).not_to have_selector ".content[data-comment-id='#{comment.id}']"
  end

  scenario "User can't delete not his question comment", js: true do
    within(".comment[data-comment-id='#{comment2.id}']") do
      expect(page).not_to have_content "delete"
    end
  end
end
