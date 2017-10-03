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
  enum status: { guest: 0, without_email: 1, pending: 2, regular: 3, admin: 99 }

  default_scope { by_reputation }
  scope :by_reputation, -> { order("reputation_sum DESC") }
  scope :by_registration, -> { unscoped.order("created_at DESC") }
  scope :alphabetically, -> { unscoped.order("username ASC") }

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :attachments, dependent: :destroy
  has_many :identities, dependent: :destroy
  has_many :reputations, dependent: :destroy

  after_update :set_pending_status
  def after_confirmation
    regular!
  end

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

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
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

  def reputations_chart_data
    unless @reputations
      @reputations = reputations.select("cast(created_at as date)", "sum(value) as value")
                                .where("created_at >= ?", 30.days.ago)
                                .group("cast(created_at as date)")
                                .order("sum(value) DESC")
      max = @reputations[0].value
      @reputations = @reputations.map { |r| { percentage: (r.value / max.to_f * 100).round(2), reputation: r.value, date: r.created_at } }
      @reputations = (29.days.ago.to_date..Date.today).map do |date|
        reputation = @reputations.select { |r| r[:date] == date }
        reputation[0] ? reputation[0] : { date: date, reputation: 0, percentage: 0 }
      end
    end
    @reputations
  end

  private

  def set_pending_status
    return unless unconfirmed_email_changed? && !unconfirmed_email.nil?
    clear_changes_information
    pending!
  end
end
