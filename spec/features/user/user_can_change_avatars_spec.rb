require "rails_helper"

RSpec.feature "Users Can Change Avatars", type: :feature do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  background do
    sign_in user
  end

  scenario "User visits his profile page and changes avatar", js: true do
    visit user_path(user.username)

    expect(page).to have_link "change avatar"
    # click_link "change avatar"
    within(".user-info") do
      page.execute_script("$('form.edit_user').show()")
      attach_file("user_avatar", "#{Rails.root}/spec/fixtures/cover_image.png")
      expect(page).to have_selector "img.user-avatar[src$='cover_image.png']"
    end
  end

  scenario "User cannot change other users' avatars" do
    visit user_path(other_user.username)

    expect(page).not_to have_link "change avatar"
    expect(page).not_to have_selector "form.edit_user"
  end
end
