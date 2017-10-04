# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tag < ApplicationRecord
  default_scope -> { alphabetical }

  has_many :questions, through: :taggings
  has_many :taggings

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { in: 1..24 }

  scope :alphabetical, -> { unscoped.order("name ASC") }
  scope :newest, -> { unscoped.order("created_at DESC") }
  scope :popular, -> { unscoped.order("questions_count DESC, created_at DESC") }

  paginates_per 30
end
