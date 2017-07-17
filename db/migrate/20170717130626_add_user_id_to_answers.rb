class AddUserIdToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :user_id, :integer
    add_index :answers, :user_id
  end
end
