require "rails_helper"

RSpec.feature "Delete Question", type: :feature do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:tags) { create_list(:tag, 5) }
  let(:question1) { create(:question, user: user1, tag_list: "test,west,best") }
  let(:question2) { create(:question, user: user2, tag_list: "test,west,best") }

  background do
    sign_in user1
  end

  scenario "User deletes his questions" do
    visit question_path(question1)

    within(".question") do
      click_on "delete-question"
    end

    expect(page).to have_selector ".alert-success", text: "deleted"
    expect(page).not_to have_content question1.body
  end

  scenario "User can't delete not his question" do
    visit question_path(question2)

    within(".question") do
      expect(page).not_to have_selector "#delete-question"
    end
  end
end
