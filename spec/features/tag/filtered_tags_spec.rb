require "rails_helper"

RSpec.feature "Fitlered Tags", type: :feature do
  let(:tags) { create_list(:tag, 3) }
  let!(:question1) { create(:question, tag_list: tags[0].name) }
  let!(:question2) { create(:question, tag_list: tags[1].name) }
  let!(:question3) { create(:question, tag_list: tags[1].name) }
  let!(:question4) { create(:question, tag_list: tags[2].name) }

  scenario "User can view tags by popularity" do
    visit tags_path
    expect(page).to have_content "popular"

    expect(page).to have_selector "a[href$=#{tags[1].name}] + a[href$=#{tags[2].name}] + a[href$=#{tags[0].name}]"
  end

  scenario "User can view tags in alphabetical order" do
    visit tags_path
    expect(page).to have_link "alphabetical"
    click_link "alphabetical"

    expect(page).to have_selector "a[href$=#{tags[0].name}] + a[href$=#{tags[1].name}] + a[href$=#{tags[2].name}]"
  end

  scenario "User can view tags sorted by the date of creation" do
    visit tags_path
    expect(page).to have_link "newest"
    click_link "newest"

    expect(page).to have_selector "a[href$=#{tags[2].name}] + a[href$=#{tags[1].name}] + a[href$=#{tags[0].name}]"
  end
end
