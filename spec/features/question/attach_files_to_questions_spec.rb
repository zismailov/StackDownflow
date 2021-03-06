require "rails_helper"

RSpec.feature "Attach File to Question", type: :feature do
  let(:user) { create(:user) }
  let(:tags) { build_list(:tag, 5) }
  let(:question) { build(:question, tags: tags, user: user) }

  background do
    sign_in user
    visit new_question_path
  end

  scenario "User uploads a file" do
    fill_in "Title", with: question.title
    fill_in "Body", with: question.body
    fill_in "Tags", with: tags.map(&:name).join(",")
    all(".new_question input[type='file']")[0].set("#{Rails.root}/spec/fixtures/cover_image.png")
    click_on "Create Question"

    expect(current_path).to match %r{\/questions\/\d+\z} # /\/questions\/\d+\z/

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    tags.each do |tag|
      expect(page).to have_content tag.name
    end
    expect(page).to have_selector "a[href$='cover_image.png']"
    expect(Attachment.last.file_identifier).to eq("cover_image.png") # _identifier is 'carrierwave' method
  end

  scenario "User uploads multiple files", js: true do
    fill_in "Title", with: question.title
    fill_in "Body", with: question.body
    page.execute_script("$('#question_tag_list').val('#{tags.map(&:name).join(',')}')")
    all(".new_question input[type='file']")[0].set("#{Rails.root}/spec/fixtures/cover_image.png")

    click_link "Add file"
    all("input[type='file']").last.set("#{Rails.root}/README.md")

    click_on "Create Question"

    expect(current_path).to match %r{\/questions\/\d+\z} # /\/questions\/\d+\z/

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    tags.each do |tag|
      expect(page).to have_content tag.name
    end
    expect(page).to have_selector "a[href$='cover_image.png']"
    expect(page).to have_selector "a[href$='README.md']"
  end

  scenario "User uploads file after a failing validation", js: true do
    all(".new_question input[type='file']")[0].set("#{Rails.root}/spec/fixtures/cover_image.png")
    click_on "Create Question"

    expect(page).to have_content "problems"

    fill_in "Title", with: question.title
    fill_in "Body", with: question.body
    page.execute_script("$('#question_tag_list').val('#{tags.map(&:name).join(',')}')")
    click_on "Create Question"

    expect(current_path).to match %r{\/questions\/\d+\z} # /\/questions\/\d+\z/
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    tags.each do |tag|
      expect(page).to have_content tag.name
    end
    expect(page).to have_selector "a[href$='cover_image.png']"
  end

  scenario "User deletes attached files", js: true do
    fill_in "Title", with: question.title
    fill_in "Body", with: question.body
    page.execute_script("$('#question_tag_list').val('#{tags.map(&:name).join(',')}')")
    all(".new_question input[type='file']")[0].set("#{Rails.root}/spec/fixtures/cover_image.png")
    click_on "Create Question"

    within(".question .question-attachments") do
      find(".delete-attachment").click
    end
    expect(page).not_to have_selector "a[href$='cover_image.png']"
  end

  scenario "User attaches a file while editing a question", js: true do
    question.save
    visit question_path(question)

    within(".question") do
      click_link "edit-question"
      all("input[type='file']")[0].set("#{Rails.root}/spec/fixtures/cover_image.png")
      click_button "Update Question"

      expect(page).to have_selector "a[href$='cover_image.png']"
    end
  end

  scenario "User can't uplaod anything but images" do
    fill_in "Title", with: question.title
    fill_in "Body", with: question.body
    fill_in "Tags", with: tags.map(&:name).join(",")
    all(".new_question input[type='file']")[0].set("#{Rails.root}/config/routes.rb")
    click_on "Create Question"

    expect(current_path).to match %r{\/questions\z}

    expect(page).to have_content "You are not allowed to upload \"rb\" files "
    expect(page).not_to have_selector "a[href$='routes.rb']"
  end
end
