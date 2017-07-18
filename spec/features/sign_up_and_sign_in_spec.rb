require "rails_helper"

# Feature: 'Singin Up' page
#  In order to ask a question
#  As a non-registered user
#  I want to have an ability to sign up and sign in

RSpec.feature "Singin Up", type: :feature do
  let!(:user) { build(:user) }

  scenario "Signs up" do
    visit root_path
    click_on "Sign up"
    fill_in "Username", with: user.username
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "Password confirmation", with: user.password
    click_button "Sign up"

    expect(page).to have_content "successfully"
  end

  scenario "Signs in" do
    user.save

    visit root_path

    click_on "Log in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect(page).to have_content "successfully"
  end
end
