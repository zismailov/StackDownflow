require "rails_helper"

RSpec.feature "Sign in", "
    In order to ask and answer questions
    As a registered user
    I want to have an ability to sign in
  ", type: :feature do

  auth = { provider: "facebook", uid: "1234567890" }
  let(:user) { create(:user) }
  let(:identity) { create(:identity, provider: auth[:provider], uid: auth[:uid], user: user) }

  scenario "Registered user signs in" do
    sign_in user.email, user.password
    expect(page).to have_content user.username
  end

  scenario "Registered user signs in with wrong email" do
    sign_in user.email.reverse, user.password
    expect(page).to have_content "Invalid email address or password"
  end

  scenario "Registered user signs in with wrong password" do
    sign_in user.email, user.password.reverse
    expect(page).to have_content "Invalid email or password"
  end

  scenario "User signs in via OAuth" do
    identity.save
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(provider: auth[:provider],
                                                                  uid: auth[:uid])
    visit new_user_session_path

    click_link "Sign in with Facebook"
    expect(page).to have_content user.username
  end
end
