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
  scope :popular, -> {
    unscoped.joins(:questions)
            .group("tags.id")
            .order("count(questions_tags.question_id) DESC, tags.created_at DESC")
  }
  scope :alphabetical, -> { unscoped.order("name ASC") }
  scope :newest, -> { unscoped.order("created_at DESC") }

  has_and_belongs_to_many :questions

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { in: 1..24 }
end
