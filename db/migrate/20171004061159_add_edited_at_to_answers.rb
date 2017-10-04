class AddEditedAtToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :edited_at, :datetime, default: nil
  end
end
