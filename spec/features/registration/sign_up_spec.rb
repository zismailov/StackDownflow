require "rails_helper"

RSpec.feature "Sign up", "
    In order to ask and answer questions
    As a non-registered user
    I want to have an ability to sign up
  ", type: :feature do

  let!(:user) { build(:user) }

  scenario "Non-registered user signs up" do
    sign_up_with user.username, user.email, user.password
    expect(page).to have_content user.username
  end

  scenario "Non-registered user signs up without filling required fields" do
    sign_up_with "", "", ""
    expect(page).to have_content "errors"
  end

  scenario "Non-registered user signs up with already taken email and username" do
    user.save!
    sign_up_with user.username, user.email, user.password
    expect(page).to have_content "Email has already been taken"
    expect(page).to have_content "Username has already been taken"
  end

  scenario "Guest user signs up via OAuth" do
    auth = { provider: "facebook", uid: "1234567890" }
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(provider: auth[:provider],
                                                                  uid: auth[:uid])

    visit new_user_registration_path
    click_link "Sign in with Facebook"
    expect(page).to have_content "#{auth[:provider]}_#{auth[:uid]}"
  end
end

def sign_up_with(username, email, password)
  visit new_user_registration_path
  fill_in "Username", with: username
  fill_in "Email", with: email
  fill_in "Password", with: password
  fill_in "Password confirmation", with: password
  click_button "Sign up"
end
