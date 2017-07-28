class RemoveQuestionIdFromAttachments < ActiveRecord::Migration[5.1]
  def change
    remove_column :attachments, :question_id
  end
end
