class AddVotesSumToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :votes_sum, :integer, default: 0
    add_index :comments, :votes_sum
  end
end
