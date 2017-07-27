require "rails_helper"

RSpec.describe Answer, type: :model do
  describe "associations" do
    it { should belong_to(:question) }
    it { should belong_to :user }
    it { should have_many :comments }
  end

  describe "validations" do
    it { should validate_presence_of :body }
    it { should validate_length_of(:body).is_at_least(10).is_at_most(5000) }
  end

  describe "instance methods" do
    describe "#mark_best!" do
      let(:question) { create(:question, tag_list: "test west east") }
      let!(:answer) { create(:answer, question: question) }

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
  end
end
