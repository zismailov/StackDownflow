require "rails_helper"

# Feature: 'Sign in' page
#  In order to ask and answer questions
#  As a registered user
#  I want to have an ability to sign in

RSpec.feature "Sign in", type: :feature do
  let!(:user) { create(:user) }

  scenario "Registered user signs in" do
    sign_in user.email, user.password
    expect(page).to have_content user.username
  end

  scenario "Registered user signs in with wrong email" do
    sign_in user.email.reverse, user.password
    expect(page).to have_content "Invalid Email or password"
  end

  scenario "Registered user signs in with wrong password" do
    sign_in user.email, user.password.reverse
    expect(page).to have_content "Invalid Email or password"
  end
end
