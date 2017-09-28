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
    it { should validate_length_of(:username).is_at_least(3).is_at_most(64) }
    it { should allow_value("pedro", "Pedro123", "Pedro_Juan").for(:username) }
    it { should_not allow_value("12", "$#!Pedro123", "Pedro Juan").for(:username) }
    it { should validate_numericality_of :age }
  end

  describe "scopes" do
    let!(:users) { create_list(:user, 3) }

    before do
      users[0].update(username: "bbb", reputation: 5)
      users[2].update(username: "aaa", reputation: 10)
      users[1].update(username: "ccc", reputation: 15)
    end

    describe "by_reputation" do
      it "returns users sorted by reputation in descending order" do
        expect(User.by_reputation).to match_array [users[1], users[2], users[0]]
      end
    end

    describe "by_registration" do
      it "returns users sorted by registration in descending order" do
        expect(User.by_registration).to match_array [users[2], users[1], users[0]]
      end
    end

    describe "alphabetically" do
      it "returns users sorted alphabetically in descending order" do
        expect(User.alphabetically).to match_array [users[2], users[0], users[1]]
      end
    end
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

      context "when user is not registered with the provider" do
        it "creates a user" do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end
        it "returns the user" do
          expect(User.find_for_oauth(auth)).to be_a User
        end
        it "sets user's email" do
          expect(User.find_for_oauth(auth).email).to eq "#{auth.provider}_#{auth.uid}@stackunderflow.dev"
        end
        it "sets user's username" do
          expect(User.find_for_oauth(auth).username).to eq "#{auth.provider}_#{auth.uid}"
        end
        it "sets user's status to 'without_email'" do
          expect(User.find_for_oauth(auth).status).to eq "without_email"
        end
        it "creates a new identity" do
          expect { User.find_for_oauth(auth) }.to change(Identity, :count).by(1)
        end
        it "sets correct provider and uid to the identity" do
          identity = User.find_for_oauth(auth).identities.first
          expect(identity.provider).to eq auth.provider
          expect(identity.uid).to eq auth.uid
        end
      end
    end
  end

  describe "after_update" do
    let!(:user) { create(:user, status: 0) }

    context "when unconfirmed_email was changed" do
      it "sets the user's status to 'pending'" do
        user.unconfirmed_email = "some_new@email.com"
        user.save
        expect(user.reload.status).to eq "pending"
      end
    end
    context "when unconfirmed_email wasn't changed" do
      it "doesn't set the user's status to 'pending'" do
        expect(user.status).to eq "guest"
      end
    end
  end
end
