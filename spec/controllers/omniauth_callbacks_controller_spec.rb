require "rails_helper"

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create :user }

  describe "facebook" do
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(provider: "facebook",
                                                                  uid: "12345")
    let(:get_facebook) { get :facebook }

    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    end

    context "as an authenticated user" do
      it "creates a new identity" do
        sign_in user
        expect { get_facebook }.to change { user.reload.identities.count }.by(1)
      end

      it "sets provider and uid for the identity" do
        sign_in user
        get_facebook
        identity = Identity.last
        expect(identity.provider).to eq OmniAuth.config.mock_auth[:facebook].provider
        expect(identity.uid).to eq OmniAuth.config.mock_auth[:facebook].uid
      end

      it "redirects to 'logins' page" do
        sign_in user
        get_facebook
        expect(response).to redirect_to logins_user_path(user)
      end
    end
  end
end
