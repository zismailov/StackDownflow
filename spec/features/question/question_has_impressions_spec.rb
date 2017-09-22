require "rails_helper"

RSpec.feature "Question Has Impressions", type: :feature do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:tags) { create_list(:tag, 2) }
  let!(:question) { create(:question, tag_list: tags.map(&:name).join(","), user: user) }

  background do
    sign_in user
  end

  scenario "Question's impressions are increased after user visiting it", js: true do
    visit root_path
    expect(page).to have_selector ".question-views", text: "0"
    visit question_path(question)
    visit root_path
    expect(page).to have_selector ".question-views", text: "1"

    visit question_path(question)
    visit root_path
    expect(page).to have_selector ".question-views", text: "2"
  end

  scenario "Question's impressions are not increased after first visit", js: true do
    visit root_path
    expect(page).to have_selector ".question-views", text: "0"
    visit question_path(question)
    visit root_path
    expect(page).to have_selector ".question-views", text: "1"

    visit question_path(question)
    visit root_path
    expect(page).to have_selector ".question-views", text: "1"
  end
end
