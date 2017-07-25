require "rails_helper"

RSpec.feature "Delete Answer", type: :feature do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user1) }
  let!(:answer1) { create(:answer, user: user1, question: question) }
  let!(:answer2) { create(:answer, user: user2, question: question) }

  background do
    sign_in user2
    visit question_path(question)
  end

  scenario "User deletes his answer", js: true do
    answer_selector = ".answers #answer_#{answer2.id}"

    within answer_selector do
      click_link "delete-answer"
    end
    page.driver.browser.switch_to.alert.accept

    expect(page).not_to have_selector answer_selector
  end

  scenario "User can't delete not his answer", js: true do
    within ".answers #answer_#{answer1.id}" do
      expect(page).not_to have_selector "#delete-answer"
    end
  end
end
