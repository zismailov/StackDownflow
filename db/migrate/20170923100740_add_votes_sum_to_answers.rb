class AddVotesSumToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :votes_sum, :integer, default: 0
    add_index :answers, :votes_sum
  end
end
