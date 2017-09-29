class CreateTaggings < ActiveRecord::Migration[5.1]
  def change
    create_table :taggings do |t|
      t.integer :question_id
      t.integer :tag_id

      t.timestamps
    end    
    add_index :taggings, [:question_id, :tag_id], unique: true
  end
end
