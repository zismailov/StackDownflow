require "rails_helper"

RSpec.feature "Edit Question", type: :feature do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:tags) { create_list(:tag, 5) }
  let(:question1) { create(:question, user: user1, tag_list: tags.map(&:name).join(",")) }
  let(:question2) { create(:question, user: user2, tag_list: tags.map(&:name).join(",")) }

  background do
    sign_in user1
  end

  scenario "User edits his question", js: true do
    visit question_path(question1)

    within(".question") do
      click_link "edit-question"
      expect(page).to have_selector "textarea#question_body"

      fill_in "Title", with: question1.title.reverse
      fill_in "Body", with: question1.body.reverse
      page.execute_script("$('#question_tag_list').val('edit-me')")
      click_button "Update Question"

      expect(page).not_to have_content "problem"
      expect(page).not_to have_selector "textarea#question_body"
    end

    expect(page).to have_content question1.body.reverse
    expect(page).to have_content question1.title.reverse
    expect(page).to have_content "edit-me"
  end

  scenario "User can't edit not his question", js: true do
    visit question_path(question2)

    expect(page).not_to have_selector "#edit-question"
  end
end
