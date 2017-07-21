require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many :questions }
    it { should have_many :answers }
    it { is_expected.to have_many :comments }
  end

  describe "validations" do
    it { should validate_presence_of :username }
    it { should validate_uniqueness_of(:username).case_insensitive }
    it { should validate_length_of(:username).is_at_least(3).is_at_most(16) }
    it { should allow_value("pedro", "Pedro123", "Pedro_Juan").for(:username) }
    it { should_not allow_value("12", "$#!Pedro123", "Pedro Juan").for(:username) }
  end
end
