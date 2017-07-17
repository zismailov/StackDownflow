require "rails_helper"

RSpec.describe QuestionsController, type: :controller do
  describe "#index" do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it "returns a list of questions" do
      expect(Question.all).to eq(questions)
    end

    it "responds successfully" do
      expect(response).to be_success
    end
  end

  describe "#show" do
    let(:question) { create(:question) }
    before { get :show, params: { id: question.id } }

    it "responds successfully" do
      expect(response).to be_success
    end
  end

  describe "#create" do
    let(:user) { create(:user) }

    before do
      allow(controller).to receive(:user_signed_in?) { true }
      allow(controller).to receive(:current_user) { user }
    end

    context "with valid data" do
      let(:question) { create(:question, user: user) }

      it "creates a new question" do
        expect {
          post :create, params: { question: attributes_for(:question) }
        }.to change(Question, :count).by(1)
      end

      it "increases current user's questions count" do
        expect {
          post :create, params: { question: attributes_for(:question) }
        }.to change(user.questions, :count).by(1)
      end
    end

    context "with invalid data" do
      it "doesn't create a new question" do
        expect {
          post :create, params: { question: attributes_for(:invalid_question, user: user) }
        }.not_to change(Question, :count)
      end

      it "doesn't increase current user's questions count" do
        expect {
          post :create, params: { question: attributes_for(:invalid_question, user: user) }
        }.not_to change(user.questions, :count)
      end
    end
  end
end
