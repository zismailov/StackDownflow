require "rails_helper"

RSpec.describe Impression, type: :model do
  describe "associations" do
    it { should belong_to :question }
    it { should belong_to :user }
  end

  describe "validations" do
    it { should validate_presence_of :remote_ip }
    it { should validate_presence_of :user_agent }
  end
end
