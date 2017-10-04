require "rails_helper"

RSpec.shared_examples "guest abilities" do
  it { should be_able_to :read, Question }
  it { should be_able_to :read, Answer }
  it { should be_able_to :read, Comment }
  it { should be_able_to :read, User }
  it { should be_able_to :read, Tag }
  it { should be_able_to :popular, Question }
  it { should be_able_to :unanswered, Question }
  it { should be_able_to :active, Question }
  it { should be_able_to :tagged, Question }
  it { should be_able_to :by_registration, User }
  it { should be_able_to :alphabetically, User }
  it { should be_able_to :popular, Tag }
  it { should be_able_to :newest, Tag }

  it { should_not be_able_to :manage, :all }
end

RSpec.shared_examples "without email abilities" do
  it { should be_able_to :update, user }
  it { should be_able_to :read, user }
  it { should be_able_to :profile, user }

  it { should_not be_able_to :update, user2 }
  it { should_not be_able_to :profile, user2 }
end

describe Ability do
  subject(:ability) { Ability.new(user) }
  let(:user) { nil }

  describe "guest" do
    it_behaves_like "guest abilities"
  end

  describe "without_email" do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }

    before { user.without_email! }

    it_behaves_like "guest abilities"
    it_behaves_like "without email abilities"
  end

  describe "pending" do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }

    before { user.pending! }

    it_behaves_like "guest abilities"
    it_behaves_like "without email abilities"
  end

  describe "regular" do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:question2) { create(:question, user: user2) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:answer2) { create(:answer, question: question2, user: user2) }
    let(:comment) { create(:question_comment, commentable: question, user: user) }
    let(:comment2) { create(:question_comment, commentable: question2, user: user2) }
    let(:attachment) { create(:attachment, attachable: question, user: user) }
    let(:attachment2) { create(:attachment, attachable: question2, user: user2) }
    let(:identity) { create(:identity, user: user) }
    let(:identity2) { create(:identity, user: user2) }

    before do
      user.regular!
    end

    it_behaves_like "guest abilities"
    it_behaves_like "without email abilities"

    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Attachment }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, identity }
    it { should_not be_able_to :create, identity2 }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Tag }
    it { should be_able_to :create, Vote }

    it { should be_able_to :logins, user }
    it { should_not be_able_to :logins, user2  }

    it { should be_able_to :vote_up, question2 }
    it { should be_able_to :vote_up, answer2 }
    it { should be_able_to :vote_up, comment2 }
    it { should_not be_able_to :vote_up, question }
    it { should_not be_able_to :vote_up, answer }
    it { should_not be_able_to :vote_up, comment }

    it { should be_able_to :vote_down, question2 }
    it { should be_able_to :vote_down, answer2 }
    it { should be_able_to :vote_down, comment2 }
    it { should_not be_able_to :vote_down, question }
    it { should_not be_able_to :vote_down, answer }
    it { should_not be_able_to :vote_down, comment }

    it { should be_able_to :update, question }
    it { should be_able_to :update, answer }
    it { should be_able_to :update, comment }
    it { should_not be_able_to :update, question2 }
    it { should_not be_able_to :update, answer2 }
    it { should_not be_able_to :update, comment2 }

    it { should be_able_to :destroy, question }
    it { should be_able_to :destroy, answer }
    it { should be_able_to :destroy, comment }
    it { should be_able_to :destroy, attachment }
    it { should_not be_able_to :destroy, question2 }
    it { should_not be_able_to :destroy, answer2 }
    it { should_not be_able_to :destroy, comment2 }
    it { should_not be_able_to :destroy, attachment2 }

    it { should be_able_to :mark_best, answer }
    it { should_not be_able_to :mark_best, answer2 }

    it { should be_able_to :add_favorite, question }
    it { should be_able_to :add_favorite, question2 }
    it { should be_able_to :remove_favorite, question }
    it { should be_able_to :remove_favorite, question2 }
  end

  describe "admin" do
    let(:user) { create(:user) }

    before do
      user.admin!
    end

    it { should be_able_to :manage, :all }
  end
end
