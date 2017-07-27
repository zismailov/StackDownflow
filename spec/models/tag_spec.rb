require "rails_helper"

RSpec.describe Tag, type: :model do
  describe "associations" do
    it { should have_and_belong_to_many :questions }
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).is_at_least(1).is_at_most(24) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should allow_value("tag", "TAG", "C++", "some_tag", "some-tag", "a123", "android-4.2").for(:name) }
    it { should_not allow_value("t a g", "123", "123a").for(:name) }
  end

  describe "methods" do
    let!(:tags) { create_list(:tag, 3) }
    let!(:question) { create(:question, tag_list: tags.map(&:name).join(" ")) }

    describe ".create_from_list" do
      context "with valid data" do
        it "creates new tags from list" do
          expect {
            Tag.create_from_list([tags[0].name, tags[1].name, tags[2].name, "macosx", "apple"])
          }.to change(Tag, :count).by(2)
        end
      end
    end
  end
end
