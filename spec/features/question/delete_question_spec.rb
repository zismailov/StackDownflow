require "rails_helper"

RSpec.feature "Delete Question", type: :feature do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:question1) { create(:question, user: user1) }
  let(:question2) { create(:question, user: user2) }

  background do
    sign_in user1
  end

  scenario "User deletes his questions" do
    visit question_path(question1)
    click_on "delete-question"

    expect(page).to have_selector ".alert-success"
    expect(page).not_to have_content question1.body
  end

  scenario "User can't delete not his question" do
    visit question_path(question2)

    expect(page).not_to have_selector "#delete-question"
  end
end
