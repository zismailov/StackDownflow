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

class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :reputation, :small_avatar_url, :medium_avatar_url,
             :tiny_avatar_url, :website, :location, :age, :full_name

  def tiny_avatar_url
    object.avatar.tiny.url
  end

  def small_avatar_url
    object.avatar.small.url
  end

  def medium_avatar_url
    object.avatar.medium.url
  end

  def reputation
    object.reputation_sum
  end
end
