require "rails_helper"

RSpec.feature "Question has tags", type: :feature do
  let!(:tags) { create_list(:tag, 5) }
  let!(:question) { create(:question, tags: tags) }

  scenario "User visits root path and sees that questions have tags" do
    visit root_path

    tags.each do |tag|
      expect(page).to have_content tag.name
    end
  end

  scenario "User visits a question and sees that the question has tags" do
    visit question_path(question)

    tags.each do |tag|
      expect(page).to have_content tag.name
    end
  end

  scenario "User visits a tag list page and sees all tags" do
    visit tags_path

    tags.each do |tag|
      expect(page).to have_content tag.name
    end
  end
end
