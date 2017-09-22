# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "rails_helper"

RSpec.describe Tag, type: :model do
  describe "associations" do
    it { should have_and_belong_to_many :questions }
  end

  describe "validations" do
    subject { Tag.new(name: "tag") }
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).is_at_least(1).is_at_most(24) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should allow_value("tag", "TAG", "C++", "some_tag", "some-tag", "a123", "android-4.2").for(:name) }
    it { should_not allow_value("t a g", "123", "123a").for(:name) }
  end

  describe "scopes" do
    let(:tags) { create_list(:tag, 3) }
    let!(:question1) { create(:question, tag_list: tags[0].name) }
    let!(:question2) { create(:question, tag_list: tags[1].name) }
    let!(:question3) { create(:question, tag_list: tags[1].name) }
    let!(:question4) { create(:question, tag_list: tags[2].name) }

    describe "popular" do
      it "returns a list of tags sorted by number of questions" do
        expect(Tag.popular).to match_array [tags[1], tags[2], tags[0]]
      end
    end
  end
end
