class AddEditedAtToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :edited_at, :datetime, default: nil
  end
end
