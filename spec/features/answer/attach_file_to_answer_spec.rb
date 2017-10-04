require "rails_helper"

RSpec.feature "Attach File to Answer", type: :feature do
  let(:user1) { create(:user) }
  let(:question) { create(:question, user: user1) }
  let(:user2) { create(:user) }
  let(:answer) { build(:answer, question: question, user: user2) }

  background do
    sign_in user2
    visit question_path(question)
  end

  scenario "User uploads a file", js: true do
    fill_in :answer_body, with: answer.body
    all("#answer-form input[type='file']")[0].set("#{Rails.root}/spec/fixtures/cover_image.png")
    click_on "Answer"

    expect(current_path).to match %r{\/questions\/\d+\z}

    expect(page).to have_content answer.body
    expect(page).to have_content answer.user.username
    expect(page).to have_link "cover_image.png"
  end

  scenario "User uploads multiple files", js: true do
    fill_in :answer_body, with: answer.body
    all("#answer-form input[type='file']")[0].set("#{Rails.root}/spec/fixtures/cover_image.png")
    click_link "Add file"
    all("input[type='file']").last.set("#{Rails.root}/Gemfile")
    click_on "Answer"

    expect(current_path).to match %r{\/questions\/\d+\z}

    expect(page).to have_content answer.body
    expect(page).to have_content answer.user.username
    expect(page).to have_link "cover_image.png"
    expect(page).to have_link "Gemfile"
  end

  scenario "User deletes attached file", js: true do
    fill_in :answer_body, with: answer.body
    all("#answer-form input[type='file']")[0].set("#{Rails.root}/spec/fixtures/cover_image.png")
    click_on "Answer"

    within(".answer .answer-attachments") do
      find(".delete-attachment").click
    end
    expect(page).not_to have_link "cover_image.png"
  end

  scenario "User attaches a file while editing a question", js: true do
    answer.save
    visit question_path(question)

    within("#answer_#{answer.id}") do
      find(".edit-answer").click
      all("input[type='file']")[0].set("#{Rails.root}/spec/fixtures/cover_image.png")
      click_button "Update Answer"

      expect(page).to have_content "cover_image.png"
    end
  end

  scenario "User can't uplaod anything but images", js: true do
    fill_in :answer_body, with: answer.body
    all("#answer-form input[type='file']")[0].set("#{Rails.root}/config/routes.rb")
    click_on "Answer"

    expect(current_path).to match %r{\/questions\/\d\z}

    expect(page).to have_content "You are not allowed to upload \"rb\" files"
    expect(page).not_to have_link "routes.rb"
  end
end
