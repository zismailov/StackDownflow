require "rails_helper"

# Feature: 'Sign up' page
#  In order to ask and answer questions
#  As a non-registered user
#  I want to have an ability to sign up

RSpec.feature "Sign up", type: :feature do
  let!(:user) { build(:user) }

  scenario "Non-registered user signs up" do
    sign_up user

    expect(page).to have_content user.username
  end
end
