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

class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  belongs_to :user
  mount_uploader :file, FileUploader

  delegate :filename, to: :file
end
