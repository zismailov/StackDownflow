class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.string :file
      t.integer :question_id

      t.timestamps
    end
    add_index :attachments, :question_id
  end
end
