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

  describe "GET #edit" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    context "as a guest" do
      before do
        allow(controller).to receive(:user_signed_in?) { false }
        allow(controller).to receive(:current_user) { user }
        get :edit, params: { id: question.id }
      end

      it "redirects to root path" do
        expect(response).to redirect_to root_path
      end
    end

    before do
      allow(controller).to receive(:user_signed_in?) { true }
      allow(controller).to receive(:current_user) { user }
      get :edit, params: { id: question.id }
    end

    context "user edits not his question" do
      let(:another_question) { create(:question) }
      before { get :edit, params: { id: another_question.id } }
      it "redirect to the questions' page" do
        expect(response).to redirect_to another_question
      end
    end
  end

  describe "PUT #update" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:edited_question) do
      edited_question = question.dup
      edited_question.title = "Edited title"
      edited_question
    end

    context "as an authorized user" do
      before do
        allow(controller).to receive(:user_signed_in?) { true }
        allow(controller).to receive(:current_user) { user }
        put :update, params: {
          id: question.id,
          question: { title: edited_question.title, body: edited_question.body }
        }
      end

      it "updates a question" do
        expect(question.reload.title).to eq "Edited title"
      end

      it "changes question's attribute" do
        expect(Question.find(question.id).title).to eq edited_question.title
      end

      it "redirects to the question page" do
        expect(response).to redirect_to question
      end
    end

    context "as a guest" do
      before do
        allow(controller).to receive(:user_signed_in?) { false }
        allow(controller).to receive(:current_user) { user }
        put :update, params: {
          id: question.id,
          question: { title: edited_question.title, body: edited_question.body }
        }
      end

      it "returns a 302 response" do
        expect(response).to have_http_status "302"
      end
    end
  end
end
