# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  vote         :integer
#  votable_id   :integer
#  votable_type :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require "rails_helper"

RSpec.describe Vote, type: :model do
  describe "associations" do
    it { should belong_to :votable }
    it { should belong_to :user }
  end

  describe "validations" do
    it { should validate_presence_of :vote }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :votable_id }
    it { should validate_presence_of :votable_type }
  end

  describe "after_save" do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:vote) { create(:vote, votable: question, user: user) }

    it "sends increment_parent_counter" do
      expect(vote).to receive(:increment_parent_counter)
      vote.save
    end

    context "when voted up" do
      it "increases votes_sum of parent" do
        expect { question.votes.create(vote: 1, user_id: user.id) }.to change { question.reload.votes_sum }
      end
    end

    context "when voted down" do
      it "decreases votes_sum of parent" do
        expect { question.votes.create(vote: -1, user_id: user.id) }.to change { question.reload.votes_sum }
      end
    end
  end

  describe "after_destroy" do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:question2) { create(:question) }

    before do
      question.vote_up(user)
      question2.vote_down(user)
    end

    it "cancels votes for question" do
      Vote.destroy_all
      expect(question.reload.votes_sum).to eq 0
      expect(question2.reload.votes_sum).to eq 0
    end
  end
end
