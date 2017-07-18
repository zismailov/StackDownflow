class User < ApplicationRecord
  has_many :questions
  has_many :answers

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { in: 3..16 },
                       format: { with: /\A[\w\d_]+\z/,
                                 message: "allows only latin letters, numbers, and underscore." }
end