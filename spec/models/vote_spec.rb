# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  vote         :integer
#  votable_id   :integer
#  votable_type :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require "rails_helper"

RSpec.describe Vote, type: :model do
  describe "associations" do
    it { should belong_to :votable }
    it { should belong_to :user }
  end

  describe "validations" do
    it { should validate_presence_of :vote }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :votable_id }
    it { should validate_presence_of :votable_type }
  end
end
