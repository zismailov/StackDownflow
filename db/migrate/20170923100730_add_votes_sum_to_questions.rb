class AddVotesSumToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :votes_sum, :integer, default: 0
    add_index :questions, :votes_sum
  end
end
