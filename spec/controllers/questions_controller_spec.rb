require "rails_helper"

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:question2) { create(:question, user: user2) }

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
    before { get :show, params: { id: question.id } }

    it "responds successfully" do
      expect(response).to be_success
    end
  end

  describe "#create" do
    let(:attributes) { attributes_for(:question) }
    let(:post_create) do
      post :create, params: { question: attributes }
    end

    context "as an authorized user" do
      context "with valid data" do
        context "with a new tag" do
          it "increases number of tags" do
            sign_in user
            expect { post_create }.to change(Tag, :count).by(5)
          end

          it "increases total number of questions" do
            sign_in user
            expect { post_create }.to change(Question, :count).by(1)
          end

          it "increases current user's number of questions" do
            sign_in user
            expect { post_create }.to change(Question, :count).by(1)
          end
        end

        context "with existing tags" do
          let!(:tag) { create(:tag) }
          let(:attributes) { attributes_for(:question, tag_list: "#{tag.name},windows,c++,macosx") }

          it "increases number of tags" do
            sign_in user
            expect { post_create }.to change(Tag, :count).by(3)
          end

          it "increases total number of questions" do
            sign_in user
            expect { post_create }.to change(Question, :count).by(1)
          end

          it "increases current user's number of questions" do
            sign_in user
            expect { post_create }.to change(Question, :count).by(1)
          end
        end
      end

      context "with invalid data" do
        let(:attributes) { attributes_for(:question, title: nil, body: nil) }

        it "doesn't increase total questions count" do
          sign_in user
          expect { post_create }.not_to change(Question, :count)
        end

        it "doesn't increase current user's questions count" do
          sign_in user
          expect { post_create }.not_to change(Question, :count)
        end
      end
    end

    context "as an guest user" do
      before { post_create }
      it "redirects to the sign in page" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#update" do
    let(:edited_question) do
      edited = question.dup
      edited.title = question.title.reverse
      edited
    end
    let(:put_update) do
      put :update, params: {
        id: question.id, question: {
          title: edited_question.title, body: question.body, tag_list: question.tag_list
        }
      }, format: :js
    end

    context "as an authorized user" do
      context "when question belongs to current user" do
        context "with valid data" do
          before do
            sign_in user
            put_update
          end

          it "changes question's attribute" do
            expect(question.reload.title).to eq edited_question.title
          end

          it "return 200 status" do
            expect(response.status).to eq 200
          end
        end

        context "with invalid data" do
          before do
            sign_in user
            edited_question.title = nil
            put_update
          end

          it "doesn't change question's attribute" do
            expect(question.reload.title).not_to eq edited_question.title
          end

          it "returns 422 status" do
            expect(response.status).to eq 422
          end
        end
      end

      context "when question doesn't belong to current user" do
        let(:question) { question2 }
        before do
          sign_in user
          put_update
        end

        it "renders root page" do
          expect(response).to redirect_to root_path
        end
      end
    end

    context "as an guest user" do
      before { put_update }

      it "doesn't change question's attribute" do
        expect(question.reload.title).not_to eq edited_question.title
      end

      it "returns 401 error" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "#destroy" do
    let!(:answer) { create(:answer, question: question) }
    let!(:comment) { create(:question_comment, commentable: question) }

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

      it "removes answers for the question" do
        sign_in user
        expect {
          delete :destroy, params: { id: question.id }
        }.to change(Answer, :count).by(-1)
      end

      it "removes comments to the question" do
        sign_in user
        expect {
          delete :destroy, params: { id: question.id }
        }.to change(Comment, :count).by(-1)
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
