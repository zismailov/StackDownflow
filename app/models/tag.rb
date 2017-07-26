class Tag < ApplicationRecord
  has_and_belongs_to_many :questions

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { in: 1..24 },
                   format: { with: /\A[a-zA-Z][\w_\.-]*[a-zA-Z0-9#\+]+\z/,
                             message: "can contain only letters, digits, ., +, -, _, and #.
                                      It must begin with a letter." }

  def self.new_from_list(tags, model)
    tags.each do |tag|
      new_tag = find_by_name(tag) || create(name: tag)
      new_tag.questions << model
    end
  end
end
