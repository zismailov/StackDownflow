require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  describe "#update" do
    let(:new_avatar) { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cover_image.png", "image/png") }
    let(:put_update) do
      put :update, params: {
        username: user.username, user: { username: user.username.reverse, avatar: new_avatar }
      }, format: :json
    end

    context "as an authenticated user" do
      context "when user is current_user" do
        before do
          sign_in user
          put_update
        end

        it "updates user's avatar" do
          expect(user.reload.avatar.path).to match(/cover_image\.png/)
        end

        it "updates user's username" do
          expect(user.username.reverse).to eq user.reload.username
        end

        it "returns json object" do
          json = JSON.parse(response.body)
          expect(json["tiny_avatar_url"]).to match(/cover_image\.png/)
          expect(json["small_avatar_url"]).to match(/cover_image\.png/)
        end

        it "returns status code 200" do
          expect(response.status).to eq 200
        end
      end

      context "when user is not current_user" do
        let(:put_update) do
          put :update, params: {
            username: user2.username, user: { avatar: new_avatar, username: user2.username.reverse }
          }, format: :json
        end
        before do
          sign_in user
          put_update
        end

        it "doesn't update user" do
          expect(user2.reload.avatar.path).not_to match(/cover_image\.png/)
          expect(user2.username.reverse).not_to eq user2.reload.username
        end

        it "returns status code 401" do
          expect(response.status).to eq 401
        end
      end
    end

    context "as an guest user" do
      before { put_update }

      it "doesn't update user" do
        expect(user.reload.avatar.path).not_to match(/cover_image\.png/)
        expect(user2.reload.username).not_to eq user.username.reverse
      end

      it "returns status code 401" do
        expect(response.status).to eq 401
      end
    end
  end
end
