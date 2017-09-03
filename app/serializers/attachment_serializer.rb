# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  file            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  attachable_id   :integer
#  attachable_type :string
#

class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :body, :user
end
