class RemoveVotesFromQuestions < ActiveRecord::Migration[5.1]
  def change
    remove_column :questions, :votes
  end
end
