require "rails_helper"

RSpec.describe Question, type: :model do
  describe "associations" do
    it { should have_many :answers }
    it { should belong_to :user }
    it { should have_many :comments }
    it { should have_and_belong_to_many :tags }
  end

  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_length_of(:title).is_at_least(5).is_at_most(512) }
    it { should validate_length_of(:body).is_at_least(10).is_at_most(5000) }
    it { should validate_presence_of :tag_list }
  end

  describe "methods" do
    let(:tags) { create_list(:tag, 1) }
    let(:question) { create(:question, tag_list: tags.map(&:name).join(" ")) }
    let!(:answer2) { create(:answer, question: question) }

    describe "#best_answer?" do
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

  describe "before_save" do
    user = FactoryGirl.create(:user)
    question = Question.new(title: "Some good title", body: "Some good body", tag_list: "test west east", user: user)

    it "creates tags" do
      expect { question.save }.to change(Tag, :count).by(3)
    end

    it "increases question's tags number" do
      expect { question.save }.to change(question.tags, :count).by(3)
    end
  end
end
