require "rails_helper"

RSpec.feature "Favorite Question", type: :feature do
  let!(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:question2) { create(:question, user: user2) }
  let(:question) { build(:question) }

  before do
    sign_in user
  end

  scenario "User adds a question to his favorite-list", js: true do
    visit question_path(question2)

    within ".question" do
      expect(page).to have_selector "a.add-to-favorites"

      find("a.add-to-favorites").click
      expect(page).to have_selector "#favorites-counter", text: "2"
    end
  end

  scenario "User views his favorite-list", js: true do
    visit question_path(question2)
    find("a.add-to-favorites").click

    visit user_path(user)
    expect(page).to have_selector ".user-profile-tabs a", text: "favorite"
    within(".user-profile-tabs") do
      click_link "favorite"
    end
    expect(page).to have_content question2.title
  end

  scenario "User removes a question from his favorite-list", js: true do
    visit question_path(question2)
    find("a.add-to-favorites").click

    within ".question" do
      expect(page).to have_selector "a.remove-from-favorites"

      find("a.remove-from-favorites").click
      expect(page).to have_selector "#favorites-counter", text: "1"
    end
  end

  scenario "When user creates a question they are automatically subscribed to it" do
    visit new_question_path
    fill_in "Title", with: question.title
    fill_in "Body", with: question.body
    fill_in "Tags", with: question.tag_list
    click_on "Create Question"

    within ".question" do
      expect(page).to have_selector "a.remove-from-favorites"
      expect(page).to have_selector "#favorites-counter", text: "1"
    end
  end
end
