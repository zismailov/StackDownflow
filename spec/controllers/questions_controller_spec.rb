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
    let(:question) { create(:question) }

    context "as an authenticated user" do
      context "with valid data" do
        it "adds a questions" do
          question_params = FactoryGirl.attributes_for(:question)
          sign_in user
          expect {
            post :create, params: { question: question_params }
          }.to change(user.questions, :count).by(1)
        end
      end

      context "with invalid data" do
        it "does not add a questions" do
          question_params = FactoryGirl.attributes_for(:invalid_question)
          sign_in user
          expect {
            post :create, params: { question: question_params }
          }.to_not change(user.questions, :count)
        end
      end
    end

    context "as a guest" do
      it "returns a 302 response" do
        question_params = FactoryGirl.attributes_for(:question)
        post :create, params: { question: question_params }
        expect(response).to have_http_status "302"
      end

      it "redirects to the sign-in page" do
        question_params = FactoryGirl.attributes_for(:question)
        post :create, params: { question: question_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#update" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, title: "Same New Question", user: other_user) }

    context "as an authorized user" do
      it "changes question's attribute" do
        question_params = FactoryGirl.attributes_for(:question, title: "New Question")
        sign_in user
        patch :update, params: { id: question.id, question: question_params }
        expect(question.reload.title).to eq "New Question"
      end
    end

    context "as an unauthorized user" do
      it "does not update the attribute" do
        question_params = FactoryGirl.attributes_for(:question, title: "New Question")
        sign_in user
        patch :update, params: { id: question.id, question: question_params }
        expect(other_question.reload.title).to eq "Same New Question"
      end
    end

    context "as a guest" do
      it "returns a 302 response" do
        question_params = FactoryGirl.attributes_for(:question)
        patch :update, params: { id: question.id, question: question_params }
        expect(response).to have_http_status "302"
      end

      it "redirects to the sign-in page" do
        question_params = FactoryGirl.attributes_for(:question)
        patch :update, params: { id: question.id, question: question_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#destroy" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    let!(:other_user) { create(:user) }
    let!(:other_question) { create(:question, user: other_user) }

    context "as an authorized user" do
      it "deletes a question" do
        sign_in user
        expect {
          delete :destroy, params: { id: question.id }
        }.to change(user.questions, :count).by(-1)
      end
    end

    context "as an unauthorized user" do
      it "does not delete the question" do
        sign_in user
        expect {
          delete :destroy, params: { id: other_question.id }
        }.to_not change(Question, :count)
      end

      it "redirects to the dashboard" do
        sign_in user
        delete :destroy, params: { id: other_question.id }
        expect(response).to redirect_to root_path
      end
    end

    context "as a guest" do
      it "returns a 302 response" do
        delete :destroy, params: { id: question.id }
        expect(response).to have_http_status "302"
      end

      it "redirects to the sign-in page" do
        delete :destroy, params: { id: question.id }
        expect(response).to redirect_to "/users/sign_in"
      end

      it "does not delete the question" do
        expect {
          delete :destroy, params: { id: question.id }
        }.to_not change(Question, :count)
      end
    end
  end
end
