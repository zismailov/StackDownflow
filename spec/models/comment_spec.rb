require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :commentable }
  end

  describe "validations" do
    it { should validate_presence_of :body }
    it { should validate_length_of(:body).is_at_least(10).is_at_most(5000) }
  end

  describe "methods" do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:tags) { create_list(:tag, 2) }
    let(:question) { create(:question, tag_list: tags.map(&:name).join(",")) }
    let!(:answer) { create(:answer, question: question) }
    let!(:comment) { create(:answer_comment, commentable: answer, user: user2) }

    describe "#total_votes" do
      it "returns total votes for the comment" do
        expect(comment.total_votes).to eq 0
      end
    end

    describe "#user_voted" do
      context "user voted up" do
        before { comment.vote_up(user) }

        it "returns user's vote" do
          expect(comment.user_voted(user)).to eq(1)
        end
      end

      context "user voted down" do
        before { comment.vote_down(user) }

        it "returns user's vote" do
          expect(comment.user_voted(user)).to eq(-1)
        end
      end

      context "user didn't vote" do
        it "returns nil" do
          expect(comment.user_voted(user)).to be_nil
        end
      end
    end

    describe "#vote_up" do
      context "when user never voted before" do
        it "increases comment's votes number" do
          expect { comment.vote_up(user) }.to change(comment, :total_votes).by(1)
        end
      end

      context "when user already voted" do
        before { comment.vote_up(user) }

        it "doesn't increase comment's votes number" do
          expect { comment.vote_up(user) }.not_to change(comment, :total_votes)
        end
      end
    end

    describe "#vote_down" do
      context "when user never voted before" do
        it "decreases comment's votes number" do
          expect { comment.vote_down(user) }.to change(comment, :total_votes).by(-1)
        end
      end

      context "when user already voted" do
        before { comment.vote_down(user) }

        it "doesn't increase comment's votes number" do
          expect { comment.vote_down(user) }.not_to change(comment, :total_votes)
        end
      end
    end

    describe "#voted_by?(user)" do
      context "when user didn't vote yet" do
        it "checks whether the user voted for the comment or not" do
          expect(comment.voted_by?(user)).to eq false
        end
      end

      context "when user already voted" do
        before do
          comment.vote_up(user)
        end
        it "checks whether the user voted for the comment or not" do
          expect(comment.voted_by?(user)).to eq true
        end
      end
    end
  end
end
