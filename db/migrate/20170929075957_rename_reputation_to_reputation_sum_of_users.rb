class RenameReputationToReputationSumOfUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :reputation, :reputation_sum
  end
end
