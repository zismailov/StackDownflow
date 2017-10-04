require "rails_helper"

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:question2) { create(:question, user: user2) }

  describe "#index" do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it "responds successfully" do
      expect(response).to be_success
    end
  end

  describe "#show" do
    let(:impression) { build(:impression, question: question) }
    let(:get_show) do
      get :show, params: { id: question.id }
    end

    before do
      request.env["REMOTE_ADDR"] = impression.remote_ip
      request.env["HTTP_USER_AGENT"] = impression.user_agent
    end

    context "when visited for the first time" do
      it "creates a new impression" do
        expect { get_show }.to change(Impression, :count).by(1)
      end
    end

    context "when visited for the second time" do
      before do
        impression.save
      end

      it "doesn't create an impression" do
        expect { get_show }.not_to change(Impression, :count)
      end
    end

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
    let(:put_update) do
      put :update, params: {
        id: question.id, question: { title: question.title.reverse, body: question.body, tag_list: question.tag_list }
      }, format: :json
    end

    context "as an authorized user" do
      context "when question belongs to current user" do
        context "with valid data" do
          before do
            sign_in user
            put_update
          end

          it "changes question's attribute" do
            expect(question.title).to eq question.reload.title.reverse
          end

          it "returns question's json" do
            json = JSON.parse(response.body)
            expect(json["title"]).to eq question.title.reverse
            expect(json["body"]).to eq question.body
            expect(json["list_of_tags"]).to eq question.tag_list
          end

          it "returns 200 status code" do
            expect(response.status).to eq 200
          end
        end

        context "with invalid data" do
          before do
            sign_in user
            put :update, params: {
              id: question.id, question: { title: "", body: question.body, tag_list: question.tag_list }
            }, format: :json
          end

          it "doesn't change question's attribute" do
            expect(question.reload.title).not_to eq question.title.reverse
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

        it "returns 401 status code" do
          expect(response.status).to eq 401
        end
      end
    end

    context "as an guest user" do
      before { put_update }

      it "doesn't change question's attribute" do
        expect(question.reload.title).not_to eq question.title.reverse
      end

      it "returns 401 error" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "#destroy" do
    let!(:answer) { create(:answer, question: question) }
    let!(:comment) { create(:question_comment, commentable: question) }
    let!(:vote) { create(:vote, votable: question, user: user2) }

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

      it "removes relating votes" do
        sign_in user
        expect {
          delete :destroy, params: { id: question.id }
        }.to change(Vote, :count).by(-1)
      end

      it "redirects to questions path" do
        sign_in user
        delete :destroy, params: { id: question.id }
        expect(response).to redirect_to questions_path
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
      it "doesn't delete a question" do
        expect {
          delete :destroy, params: { id: question.id }
        }.not_to change(Question, :count)
      end

      it "redirects to sign in path" do
        delete :destroy, params: { id: question.id }
        expect(response).to redirect_to new_user_session_path
      end

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

  describe "POST #add_favorite" do
    let!(:user) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:question2) { create(:question, user: user2) }

    let(:post_add_favorite) do
      post :add_favorite, params: { question_id: question2.id }, format: :json
    end

    context "as an authorized user" do
      before { sign_in user }

      it "adds question to user's favorite list" do
        expect { post_add_favorite }.to change { user.favorites.count }.by(1)
      end

      it "renders json with status" do
        post_add_favorite
        expect(response.status).to eq 200

        json = JSON.parse(response.body)
        expect(json["status"]).to eq "success"
        expect(json["count"]).to eq 2
      end
    end

    context "as an guest user" do
      it "doesn't add question to user's favorite list" do
        expect { post_add_favorite }.not_to change { user.favorites.count }
      end

      it "returns 401 status" do
        post_add_favorite
        expect(response.status).to eq 401
      end
    end
  end

  describe "POST #remove_favorite" do
    let!(:user) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:question2) { create(:question, user: user2) }

    let(:post_remove_favorite) do
      post :remove_favorite, params: { question_id: question.id }, format: :json
    end

    context "as an authorized user" do
      before { sign_in user }

      it "removes question from user's favorite list" do
        expect { post_remove_favorite }.to change { user.favorites.count }.by(-1)
      end

      it "renders json with status" do
        post_remove_favorite
        expect(response.status).to eq 200

        json = JSON.parse(response.body)
        expect(json["status"]).to eq "success"
        expect(json["count"]).to eq 0
      end
    end

    context "as an guest user" do
      it "doesn't remove question from user's favorite list" do
        expect { post_remove_favorite }.not_to change { user.favorite_questions.count }
      end

      it "returns 401 status" do
        post_remove_favorite
        expect(response.status).to eq 401
      end
    end
  end
end
