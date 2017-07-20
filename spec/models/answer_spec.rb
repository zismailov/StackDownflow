require "rails_helper"

RSpec.describe Answer, type: :model do
  describe "associations" do
    it { should belong_to(:question) }
    it { should belong_to :user }
  end

  describe "validations" do
    it { should validate_presence_of :body }
    it { should validate_length_of(:body).is_at_least(10).is_at_most(5000) }
  end

  describe "instance methods" do
    describe "#mark_best!" do
      it "marks answer as best" do
        answer = build(:answer)
        answer.mark_best!
        expect(answer).to be_best
      end
    end
  end
end
