class AddRecentActivityToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :recent_activity, :datetime, default: nil
  end
end
