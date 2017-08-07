require "rails_helper"

RSpec.describe Answer, type: :model do
  describe "associations" do
    it { should belong_to(:question) }
    it { should belong_to :user }
    it { should have_many :comments }
    it { should have_many :attachments }
    it { should have_many :votes }
    it { should accept_nested_attributes_for :attachments }
  end

  describe "validations" do
    it { should validate_presence_of :body }
    it { should validate_length_of(:body).is_at_least(10).is_at_most(5000) }
  end

  describe "instance methods" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question) }

    describe "#mark_best!" do
      context "when question has no best answer" do
        it "marks answer as best" do
          answer.mark_best!
          expect(answer).to be_best
        end
      end

      context "when question has a best answer" do
        let!(:best_answer) { create(:answer, question: question, best: true) }

        it "doesn't mark answer as best" do
          answer.mark_best!
          expect(answer).not_to be_best
        end
      end
    end

    describe "#total_votes" do
      it "returns total votes for the answer" do
        expect(answer.total_votes).to eq 0
      end
    end

    describe "#vote_up" do
      it "increases answer's votes number" do
        expect { answer.vote_up(user) }.to change(answer, :total_votes).by(1)
      end
    end

    describe "#vote_up" do
      it "decreases answer's votes number" do
        expect { answer.vote_down(user) }.to change(answer, :total_votes).by(-1)
      end
    end
  end
end
