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
  default_scope { by_reputation }

  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorite_questions, dependent: :destroy
  has_many :favorites, through: :favorite_questions, source: :question
  has_many :identities, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :reputations, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :age, numericality: { only_integer: true }, allow_blank: true
  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       length: { in: 3..64 },
                       format: { with: /\A[\w\d_]+\z/,
                                 message: "allows only latin letters, numbers, and underscore." }

  def after_confirmation
    regular!
  end
  after_update :set_pending_status

  scope :by_reputation, -> { order("reputation_sum DESC") }
  scope :by_registration, -> { unscoped.order(created_at: :desc) }
  scope :alphabetically, -> { unscoped.order("username ASC") }

  enum status: { guest: 0, without_email: 1, pending: 2, regular: 3, admin: 99 }

  mount_uploader :avatar, AvatarUploader
  paginates_per 28

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter, :vkontakte, :github]

  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { in: 3..64 },
                       format: { with: /\A[\w\d_]+\z/,
                                 message: "allows only latin letters, numbers, and underscore." }
  validates :age, numericality: { only_integer: true }, allow_blank: true

  mount_uploader :avatar, AvatarUploader

  def to_param
    username
  end

  def favorite?(question_id)
    favorite_ids.include?(question_id) if question_id
  end

  def add_favorite(question_id)
    favorite_questions.create(question_id: question_id) if question_id
  end

  def remove_favorite(question_id)
    favorite_questions.find_by(question_id: question_id).destroy if question_id && favorite?(question_id)
  end

  def reputations_chart_data
    @reputations ||= ReputationChartService.new(self, 30).chart
  end

  def self.find_for_oauth(auth)
    identity = Identity.find_by(provider: auth.provider, uid: auth.uid)
    return identity.user if identity

    username = "#{auth.provider}_#{auth.uid}"
    user = User.new(email: "#{username}@stackdownflow.dev", username: username, password: Devise.friendly_token)
    user.skip_confirmation!
    user.status = "without_email"
    user.save!
    user.identities.create(provider: auth.provider, uid: auth.uid)
    user
  end

  def self.send_daily_digest
    questions = Question.where("created_at >= ?", 1.day.ago).to_a

    find_each do |user|
      DailyMailer.digest(user, questions).deliver
    end
  end

  private

  def set_pending_status
    return unless unconfirmed_email_changed? && !unconfirmed_email.nil?
    clear_changes_information
    pending!
  end
end
