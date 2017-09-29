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
    it { is_expected.to have_many :taggings }
    it { is_expected.to have_many :questions }
  end

  describe "validations" do
    subject { Tag.new(name: "tag") }
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).is_at_least(1).is_at_most(24) }
    it { should validate_uniqueness_of(:name).case_insensitive }
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

    describe "alphabetical" do
      it "returns a list of tags in alphabetical order" do
        expect(Tag.popular).to match_array [tags[0], tags[1], tags[2]]
      end
    end
  end
end
