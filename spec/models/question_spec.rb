require "rails_helper"

RSpec.describe Question, type: :model do
  describe "associations" do
    it { should have_many :answers }
    it { should belong_to :user }
    it { should have_many :comments }
  end

  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_length_of(:title).is_at_least(5).is_at_most(512) }
    it { should validate_length_of(:body).is_at_least(10).is_at_most(5000) }
  end

  describe "instance methods" do
    let(:question) { create(:question) }
    let!(:answer2) { create(:answer, question: question) }

    describe "#has_best_answer?" do
      context "when question has a best answer" do
        let!(:answer1) { create(:answer, best: true, question: question) }

        it "has a best answer" do
          expect(question.best_answer?).to be
        end
      end

      context "when question has no best answer" do
        it "has no best answer" do
          expect(question.best_answer?).not_to be
        end
      end
    end
  end
end
