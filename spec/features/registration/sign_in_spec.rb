require "rails_helper"

# Feature: 'Sign in' page
#  In order to ask and answer questions
#  As a registered user
#  I want to have an ability to sign in

RSpec.feature "Sign in", type: :feature do
  let!(:user) { create(:user) }

  scenario "Registered user signs in" do
    sign_in user

    expect(page).to have_content user.username
  end
end
