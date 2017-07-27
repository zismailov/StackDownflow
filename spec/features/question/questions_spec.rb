require "rails_helper"

RSpec.feature "Question", "
    In order to resolve a problem
    As a registered and authenticated user
    I want to have an ability to ask, edit, and delete questions
  ", type: :feature do

    let(:user) { create(:user) }
    let(:tags) { build_list(:tag, 5) }
    let(:question) { build(:question, tags: tags) }

    background do
      sign_in user
      visit new_question_path
    end

    scenario "Authenticated user asks a question" do
      fill_in "Title", with: question.title
      fill_in "Body", with: question.body
      fill_in "Tags", with: tags.map(&:name).join(",")
      attach_file("File", "#{Rails.root}/spec/fixtures/cover_image.png")
      click_on "Create Question"

      expect(current_path).to match %r{\/questions\/\d+\z} # /\/questions\/\d+\z/

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      tags.each do |tag|
        expect(page).to have_content tag.name
      end
      expect(page).to have_content "cover_image.png"
      expect(Attachment.last.file_identifier).to eq("cover_image.png") # _identifier is 'carrierwave' method
    end

    scenario "Authenticated user asks a question without filling required fields" do
      click_on "Create Question"

      expect(current_path).to match %r{\/questions\z}

      expect(page).to have_content "problems"
    end

    scenario "User creates a question without specifying a tag" do
      fill_in "Title", with: question.title
      fill_in "Body", with: question.body
      fill_in "Tags", with: ""
      click_on "Create Question"

      expect(current_path).to match %r{\/questions\z}
      expect(page).to have_content "problems"
    end
  end
