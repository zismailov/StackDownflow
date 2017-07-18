require "rails_helper"

RSpec.feature "Edit Question", type: :feature do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  scenario "User edits his question" do
    sign_in user

    visit question_path(question)

    click_link "edit-question"

    expect(page).to have_content "Body"

    fill_in "Body", with: question.body.reverse
    click_on "Edit"

    expect(page).to have_content question.body.reverse
  end
end
