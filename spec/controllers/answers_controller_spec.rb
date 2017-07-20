require "rails_helper"

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user2) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe "#create" do
    let(:attributes) { attributes_for :answer }
    let(:post_create) do
      post :create, params: { question_id: question.id, answer: attributes }
    end

    context "as an authenticated user" do
      context "with valid data" do
        it "increases a total number of answer" do
          sign_in user
          expect { post_create }.to change(question.answers, :count).by(1)
        end

        it "increases a total number of user's answer" do
          sign_in user
          expect { post_create }.to change(user.answers, :count).by(1)
        end
      end

      context "with invalid data" do
        let(:attributes) { attributes_for :invalid_answer }

        it "doesn't increase a total number of answers" do
          expect { post_create }.not_to change(question.answers, :count)
        end

        it "doesn't increase a total number of user's answers" do
          expect { post_create }.not_to change(user.answers, :count)
        end
      end
    end

    context "as a guest" do
      before { post_create }
      it "redirects to sign in page" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#update" do
    let(:edited_answer) do
      edited_answer = answer.dup
      edited_answer.body = answer.body.reverse
      edited_answer
    end

    context "as an authenticated user" do
      context "with valid attributes" do
        it "changes answer's field" do
          sign_in user
          put :update, params: { question_id: question.id, id: answer.id, answer: { body: edited_answer.body } }
          expect(Answer.find(answer.id).body).to eq edited_answer.body
        end
      end

      context "with invalid attributes" do
        before do
          edited_answer.body = nil
          put :update, params: { question_id: question.id, id: answer.id, answer: { body: edited_answer.body } }
        end

        it "doesn't change answer's field" do
          sign_in user
          expect(answer.body).not_to eq edited_answer.body
        end
      end
    end

    context "as an guest user" do
      before do
        put :update, params: { question_id: question.id, id: answer.id, answer: { body: edited_answer.body } }
      end

      it "doesn't change answer's attribute" do
        expect(answer.body).not_to eq edited_answer.body
      end

      it "redirects to root path" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#destroy" do
    let(:delete_destroy) do
      delete :destroy, params: { question_id: question, id: answer }
    end
    before { answer }

    context "as an authenticated user" do
      context "when asnwer belongs to current user" do
        it "deletes the answer" do
          sign_in user
          expect { delete_destroy }.to change(Answer, :count).by(-1)
        end

        it "redirects to root path" do
          sign_in user
          delete_destroy
          expect(response).to redirect_to root_path
        end
      end

      context "when answer doesn't belong to current user" do
        let(:answer) { create(:answer, question: question, user: user2) }

        it "doesn't delete the answer" do
          sign_in user
          expect { delete_destroy }.not_to change(Answer, :count)
        end

        it "redirects to root path" do
          sign_in user
          delete_destroy
          expect(response).to redirect_to root_path
        end
      end
    end

    context "as an guest user" do
      it "doesn't delete the answer" do
        expect { delete_destroy }.not_to change(Answer, :count)
      end

      it "redirects to sign in path" do
        delete_destroy
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#mark_best" do
    let(:mark_best) do
      post :mark_best, params: { question_id: question, id: answer }
    end

    context "as an authenticated user" do
      context "when question belongs to current user" do
        let(:question) { create(:question, user: user) }
        let(:answer) { create(:answer, question: question, user: user2) }
        before do
          sign_in user
          mark_best
        end

        it "marks the answer as best" do
          expect(answer.reload).to be_best
        end

        it "redirects to question page" do
          expect(response).to redirect_to question
        end
      end

      context "when question doesn't belong to current user" do
        before do
          sign_in user
          mark_best
        end
        it "redirects to question page" do
          expect(response).to redirect_to question
        end
      end
    end

    context "as an guest user" do
      before { mark_best }
      it "doesn't mark the answer as best" do
        expect(answer.reload).not_to be_best
      end

      it "redirects to sign in page" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
