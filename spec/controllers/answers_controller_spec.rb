require "rails_helper"

RSpec.describe AnswersController, type: :controller do
  describe "#create" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question) }
    let(:invalid_answer) { create(:invalid_answer, question: question) }

    context "as an authenticated user" do
      before do
        allow(controller).to receive(:user_signed_in?) { true }
        allow(controller).to receive(:current_user) { user }
      end

      context "with valid data" do
        it "increases a total number of answer" do
          expect {
            post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
          }.to change(question.answers, :count).by(1)
        end

        it "increases a total number of user's answer" do
          expect {
            post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
          }.to change(user.answers, :count).by(1)
        end
      end

      context "with invalid data" do
        it "doesn't increase a total number of answers" do
          expect {
            post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) }
          }.not_to change(question.answers, :count)
        end

        it "doesn't increase a total number of user's answers" do
          expect {
            post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) }
          }.not_to change(user.answers, :count)
        end
      end
    end

    context "as a guest" do
      before do
        allow(controller).to receive(:user_signed_in?) { false }
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
      end

      it "returns a 302 response" do
        expect(response).to have_http_status "302"
      end

      it "redirects to root path with flash message" do
        expect(flash[:danger]).not_to be_nil
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#edit" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    context "as an guest" do
      before do
        allow(controller).to receive(:user_signed_in?) { false }
        get :edit, params: { question_id: question.id, id: answer.id }
      end
      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#update" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    context "as an authenticated user" do
      before do
        allow(controller).to receive(:user_signed_in?) { true }
        allow(controller).to receive(:current_user) { user }
      end
      context "with valid attributes" do
        let(:edited_answer) do
          edited_answer = answer.dup
          edited_answer.body = answer.body.reverse
          edited_answer
        end
        before do
          put :update, params: { question_id: question.id, id: answer.id, answer: { body: edited_answer.body } }
        end

        it "changes answer's field" do
          expect(Answer.find(answer.id).body).to eq edited_answer.body
        end

        it "redirects to the answer's question page" do
          expect(response).to redirect_to question_path(question.id)
        end
      end

      context "with invalid attributes" do
        let(:edited_answer) do
          edited_answer = answer.dup
          edited_answer.body = ""
          edited_answer
        end
        before do
          put :update, params: { question_id: question.id, id: answer.id, answer: { body: edited_answer.body } }
        end

        it "doesn't change answer's field" do
          expect(answer.body).not_to eq edited_answer.body
        end
      end
    end

    context "as an guest user" do
      let(:edited_answer) do
        edited_answer = answer.dup
        edited_answer.body = answer.body.reverse
        edited_answer
      end
      before do
        allow(controller).to receive(:user_signed_in?) { false }
        put :update, params: { question_id: question.id, id: answer.id, answer: { body: edited_answer.body } }
      end

      it "doesn't change answer's attribute" do
        expect(answer.body).not_to eq edited_answer.body
      end

      it "redirects to root path" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#destroy" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }

    context "as an authenticated user" do
      before do
        allow(controller).to receive(:user_signed_in?) { true }
        allow(controller).to receive(:current_user) { user }
        answer
      end

      it "deletes an answer" do
        expect {
          delete :destroy, params: { question_id: question, id: answer }
        }.to change(Answer, :count).by(-1)
      end

      it "redirects to root path" do
        delete :destroy, params: { question_id: question, id: answer.id }
        expect(response).to redirect_to root_path
      end
    end

    context "as an guest user" do
      before do
        allow(controller).to receive(:user_signed_in?) { false }
        answer
      end

      it "doesn't delete a answer" do
        expect {
          delete :destroy, params: { question_id: question, id: answer }
        }.not_to change(Answer, :count)
      end

      it "redirects to root path" do
        delete :destroy, params: { question_id: question, id: answer.id }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#mark_best" do
    let(:user) { create(:user) }
    let(:answered_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: answered_user) }

    context "as an authenticated user" do
      before do
        allow(controller).to receive(:user_signed_in?) { true }
        allow(controller).to receive(:current_user) { user }
        post :mark_best, params: { question_id: question, id: answer }
      end

      it "marks an answer as best" do
        expect(answer.reload).to be_best
      end

      it "redirects to question page" do
        expect(response).to redirect_to question
      end
    end

    context "as an guest user" do
      before do
        allow(controller).to receive(:user_signed_in?) { false }
        post :mark_best, params: { question_id: question, id: answer }
      end

      it "doesn't mark an answer as best" do
        expect(answer.reload).not_to be_best
      end

      it "redirects to root path" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
