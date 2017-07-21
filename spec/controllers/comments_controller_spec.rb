require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:comment) { build(:comment, user: user) }

  describe "#create" do
    let(:attributes) { attributes_for(:comment) }
    let(:post_create) do
      post :create, params: { question_id: question.id, comment: attributes }
    end

    context "as an authenticated user" do
      context "with valid data" do
        it "adds a new comment to database" do
          sign_in user
          expect { post_create }.to change(Comment, :count).by(1)
        end

        it "redirects to the question page" do
          sign_in user
          post_create
          expect(response).to redirect_to question_path(question)
        end
      end

      context "with invalid data" do
        let(:attributes) { attributes_for :invalid_comment }

        it "doesn't add a new comment to database" do
          sign_in user
          expect { post_create }.not_to change(Comment, :count)
        end

        it "redirects to the question page" do
          sign_in user
          post_create
          expect(response).to redirect_to question_path(question)
        end
      end
    end

    context "as an guest user" do
      it "redirects to the sign in page" do
        post_create
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
