class AddReputationToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :reputation, :integer, default: 0, nil: false
  end
end
