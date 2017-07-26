require "rails_helper"

RSpec.feature "Question has tags", type: :feature do
  let(:tag) { create(:tag) }
  let(:question) { create(:question, tag: tag) }

  scenario "User visits a root path and sees that questions have tags" do
    visit root_path

    expect(page).to have_content tag.name
  end

  scenario "User visits a question and sees that the question has tags" do
    visit question_path(question)

    expect(page).to have_content tag.name
  end

  scenario "User visits a tag list page and sees all tags" do
    visit tags_path

    expect(page).to have_content tag.name
  end
end
