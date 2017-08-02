require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:comment) { create(:question_comment, user: user, commentable: question) }
  let!(:comment2) { create(:question_comment, user: user2, commentable: question) }

  describe "#create" do
    let(:attributes) { attributes_for(:question_comment) }
    let(:post_create) do
      post :create, params: { question_id: question.id, comment: attributes }, format: :json
    end

    context "as an authenticated user" do
      context "with valid data" do
        it "adds a new comment to database" do
          sign_in user
          expect { post_create }.to change(Comment, :count).by(1)
        end

        it "returns 201 status" do
          sign_in user
          post_create
          expect(response.status).to eq 201
        end
      end

      context "with invalid data" do
        let(:attributes) { attributes_for(:question_comment, body: nil) }

        it "doesn't add a new comment to database" do
          sign_in user
          expect { post_create }.not_to change(Comment, :count)
        end

        it "returns 422 status" do
          sign_in user
          post_create
          expect(response.status).to eq 422
        end
      end
    end

    context "returns 401 error" do
      it "redirects to the sign in page" do
        post_create
        expect(response.status).to eq 401
      end
    end
  end

  describe "#update" do
    let(:attributes) { attributes_for(:question_comment, body: comment.body.reverse) }
    let(:put_update) do
      put :update, params: { question_id: question.id, id: comment.id, comment: attributes }, format: :json
    end

    context "as an authenticated user" do
      context "comment belongs to current user" do
        context "with valid data" do
          before do
            sign_in user
            put_update
          end

          it "changes comment's attribute" do
            expect(comment.reload.body).to eq attributes[:body]
          end

          it "returns 200 status" do
            expect(response.status).to eq 200
          end
        end

        context "with invalid data" do
          let(:attributes) { attributes_for(:question_comment, body: "") }
          before do
            sign_in user
            put_update
          end

          it "doesn't change comment's attribute" do
            expect(comment.reload.body).not_to eq attributes[:body]
          end

          it "returns 422 status" do
            expect(response.status).to eq 422
          end
        end
      end

      context "comment doesn't belong to current user" do
        let(:comment) { comment2 }
        before do
          sign_in user
          put_update
        end

        it "returns 403 error" do
          expect(response.status).to eq 403
        end
      end
    end

    context "as an guest user" do
      before { put_update }

      it "returns 401 error" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "#destroy" do
    let(:delete_destroy) do
      delete :destroy, params: { question_id: question.id, id: comment.id }, format: :json
    end

    context "as an authenticated user" do
      context "when comment belongs to current user" do
        before { sign_in user }
        it "removes the comment" do
          expect { delete_destroy }.to change(Comment, :count).by(-1)
        end

        it "returns 204 status" do
          delete_destroy
          expect(response.status).to eq 204
        end
      end

      context "when comment doesn't belong to current user" do
        let(:comment) { comment2 }
        before { sign_in user }
        it "doesn't remove the comment" do
          expect { delete_destroy }.not_to change(Comment, :count)
        end

        it "returns 403 error" do
          delete_destroy
          expect(response.status).to eq 403
        end
      end
    end

    context "as an guest user" do
      it "returns 401 error" do
        delete_destroy
        expect(response.status).to eq 401
      end
    end
  end
end
