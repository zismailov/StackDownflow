require "rails_helper"

RSpec.feature "Tag Pages", type: :feature do
  let!(:question1) { create(:question, tag_list: "tag1,tag2") }
  let!(:question2) { create(:question, tag_list: "tag1") }
  let!(:question3) { create(:question, tag_list: "tag2") }

  scenario "User visits tag page" do
    visit tags_path

    click_link "tag1"
    expect(page).to have_content question1.title
    expect(page).to have_content question2.title

    visit tags_path
    click_link "tag2"
    expect(page).to have_content question1.title
    expect(page).to have_content question3.title
  end
end
