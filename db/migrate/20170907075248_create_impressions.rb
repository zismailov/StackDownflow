class CreateImpressions < ActiveRecord::Migration[5.1]
  def change
    create_table :impressions do |t|
      t.integer :question_id
      t.integer :user_id
      t.string :remote_ip
      t.string :user_agent

      t.timestamps
    end
    add_index :impressions, [:question_id, :user_id, :remote_ip, :user_agent], name: :by_all_fields
  end
end
