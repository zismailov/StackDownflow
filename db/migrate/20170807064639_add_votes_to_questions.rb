class AddVotesToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :votes, :integer, default: 0, null: false
  end
end
