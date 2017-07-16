require "rails_helper"

RSpec.describe Question, type: :model do
  it { should have_many :answers }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_least(5).is_at_most(512) }
  it { should validate_length_of(:body).is_at_least(10).is_at_most(5000) }
end
