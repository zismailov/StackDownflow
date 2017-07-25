require "rails_helper"

RSpec.feature "Sign up", "
    In order to ask and answer questions
    As a non-registered user
    I want to have an ability to sign up
  ", type: :feature do

  let!(:user) { build(:user) }

  scenario "Non-registered user signs up" do
    sign_up user.username, user.email, user.password
    expect(page).to have_content user.username
  end

  scenario "Non-registered user signs up without filling required fields" do
    sign_up "", "", ""
    expect(page).to have_content "errors"
  end

  scenario "Non-registered user signs up with already taken email and username" do
    user.save!
    sign_up user.username, user.email, user.password
    expect(page).to have_content "Email has already been taken"
    expect(page).to have_content "Username has already been taken"
  end
end
