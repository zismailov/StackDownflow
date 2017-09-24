# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string           default(""), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many :questions }
    it { should have_many :answers }
    it { should have_many :comments }
    it { should have_many :votes }
    it { should have_many :attachments }
    it { should have_many :identities }
  end

  describe "validations" do
    it { should validate_presence_of :username }
    it { should validate_uniqueness_of(:username).case_insensitive }
    it { should validate_length_of(:username).is_at_least(3).is_at_most(32) }
    it { should allow_value("pedro", "Pedro123", "Pedro_Juan").for(:username) }
    it { should_not allow_value("12", "$#!Pedro123", "Pedro Juan").for(:username) }
    it { should validate_numericality_of :age }
  end

  describe "methods" do
    describe ".find_for_oauth" do
      let!(:user) { create(:user) }
      let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456") }

      context "when user is already registered with the provider" do
        before do
          user.identities.create(provider: auth.provider, uid: auth.uid)
        end

        it "returns the user" do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context "when user is not registered yet with the provider" do
        let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456", info: { email: user.email }) }

        context "when user already exists" do
          it "doesn't create a new user" do
            expect { User.find_for_oauth(auth) }.not_to change(User, :count)
          end
          it "creates a new identity" do
            expect { User.find_for_oauth(auth) }.to change(user.identities, :count).by(1)
          end
          it "creates a new identity with correct provider and uid" do
            identity = User.find_for_oauth(auth).identities.first
            expect(identity.provider).to eq auth.provider
            expect(identity.uid).to eq auth.uid
          end
          it "returns existing user" do
            expect(User.find_for_oauth(auth)).to eq user
          end
        end

        context "when user doesn't exist yet" do
          let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456", info: { email: "test@mail.com" }) }

          context "when email provided by provider" do
            it "sets user's email to the provided" do
              expect(User.find_for_oauth(auth).email).to eq "test@mail.com"
            end
          end

          context "when email is not provided by provider" do
            let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456", info: {}) }

            it "sets user's email to a generated one" do
              expect(User.find_for_oauth(auth).email).to eq "#{auth.provider}_#{auth.uid}@stackdownflow.dev"
            end
          end

          it "creates a new user" do
            expect { User.find_for_oauth(auth) }.to change(User, :count)
          end

          it "creates a new identity for the user" do
            expect { User.find_for_oauth(auth) }.to change(Identity, :count)
          end

          it "creates a new idetity with correct provider and uid" do
            identity = User.find_for_oauth(auth).identities.first
            expect(identity.provider).to eq auth.provider
            expect(identity.uid).to eq auth.uid
          end

          it "sets username" do
            expect(User.find_for_oauth(auth).username).to eq "#{auth.provider}_#{auth.uid}"
          end

          it "returns the new user" do
            expect(User.find_for_oauth(auth)).to be_a User
          end
        end
      end
    end
  end
end
