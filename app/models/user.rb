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

class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :comments
  has_many :votes
  has_many :attachments
  has_many :identities

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { in: 3..32 },
                       format: { with: /\A[\w\d_]+\z/,
                                 message: "allows only latin letters, numbers, and underscore." }

  mount_uploader :avatar, AvatarUploader

  def to_param
    username
  end

  def self.find_for_oauth(auth)
    identity = Identity.find_by(provider: auth.provider, uid: auth.uid)
    return identity.user if identity

    user = User.find_by(email: auth.info["email"])
    unless user
      password = Devise.friendly_token
      username = "#{auth.provider}_#{auth.uid}"
      user = User.create(email: auth.info[:email], username: username, password: password)
    end
    user.identities.create(provider: auth.provider, uid: auth.uid)
    user
  end
end
