class Attachment < ApplicationRecord
  belongs_to :question
  mount_uploader :file, FileUploader
end
