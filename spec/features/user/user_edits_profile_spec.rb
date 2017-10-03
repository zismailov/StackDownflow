require "rails_helper"

RSpec.feature "User Edits His Profile", type: :feature do
  let!(:user) { create :user }
  let!(:other_user) { create(:user) }

  background { sign_in user }

  scenario "User visits 'Edit profile' page" do
    visit user_path(user)

    expect(page).to have_link "edit-profile"
    click_link "edit-profile"
    expect(page).to have_content "Edit"
  end

  scenario "User cannot visit other user's 'Edit profile' page" do
    visit user_path(other_user)
    expect(page).not_to have_link "edit-profile"
  end

  scenario "User visits his profile page and changes avatar", js: true do
    visit edit_user_path(user)

    expect(page).to have_link "change avatar"
    within(".user-info") do
      page.execute_script("$('form.change-avatar-form').show()")
      attach_file("user_avatar", "#{Rails.root}/spec/fixtures/cover_image.png")
      expect(page).to have_selector "img.user-avatar[src$='cover_image.png']"
    end
  end

  scenario "User edits his username" do
    visit edit_user_path(user)

    fill_in "Username", with: user.username.reverse
    click_button "Update User"

    expect(page.current_path).to match %r{\/users\/#{user.username.reverse}\z}
    expect(page).to have_content user.username.reverse
  end

  scenario "User cannot take already taken username" do
    visit edit_user_path(user)

    fill_in "Username", with: other_user.username
    click_button "Update User"

    expect(page.current_path).to match %r{\/users\/#{user.username}\z}
    expect(page).to have_content "Failed"
    expect(page).to have_content "has already been taken"
  end

  scenario "User adds additional info" do
    new_info = { website: "apple.com", location: "San Francisco", age: 30, full_name: "Duncan Macleod" }
    visit edit_user_path(user)

    fill_in "Website", with: new_info[:website]
    fill_in "Location", with: new_info[:location]
    fill_in "Age", with: new_info[:age]
    fill_in "Full name", with: new_info[:full_name]

    click_button "Update User"

    expect(page).to have_content new_info[:website]
    expect(page).to have_content new_info[:location]
    expect(page).to have_content new_info[:age]
    expect(page).to have_content new_info[:full_name]
  end
end
