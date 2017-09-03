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
  has_and_belongs_to_many :questions

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { in: 1..24 },
                   format: { with: /\A[a-zA-Z][\w#\+\-\.]*\z/,
                             message: "can include only: latin letters, digits, ., +, -, _, and #.
                                       Every tag must begin with a letter." }
end
