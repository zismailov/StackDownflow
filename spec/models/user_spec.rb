# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string           default(""), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many :questions }
    it { should have_many :answers }
    it { should have_many :comments }
    it { should have_many :votes }
    it { should have_many :attachments }
  end

  describe "validations" do
    it { should validate_presence_of :username }
    it { should validate_uniqueness_of(:username).case_insensitive }
    it { should validate_length_of(:username).is_at_least(3).is_at_most(16) }
    it { should allow_value("pedro", "Pedro123", "Pedro_Juan").for(:username) }
    it { should_not allow_value("12", "$#!Pedro123", "Pedro Juan").for(:username) }
  end
end
