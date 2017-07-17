require "rails_helper"

RSpec.describe AnswersController, type: :controller do
  describe "#create" do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let(:invalid_answer) { question.create(:invalid_answer) }

    context "with valid data" do
      it "creates a new answer for a question" do
        expect do
          post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        end.to change(question.answers, :count).by(1)
      end
    end

    context "with invalid data" do
      it "doesn't create a new answer for a question" do
        expect do
          post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) }
        end.not_to change(question.answers, :count)
      end
    end
  end
end
