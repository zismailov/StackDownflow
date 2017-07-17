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
    context "with valid data" do
      let(:question) { create(:question) }

      it "creates a new question" do
        expect do
          post :create, params: { question: attributes_for(:question) }
        end.to change(Question, :count).by(1)
      end
    end

    context "with invalid data" do
      let(:invalid_question) { create(:invalid_question) }

      it "doesn't create a new question" do
        expect do
          post :create, params: { question: attributes_for(:invalid_question) }
        end.not_to change(Question, :count)
      end
    end
  end
end
