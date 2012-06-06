class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.string  :taggable_type, :default => ''
      t.integer :taggable_id
      t.integer :scope_id
      t.string  :tag, :default => ''
    end
    
    add_index :taggings, :tag_id
    add_index :taggings, [:tag]
    add_index :taggings, [:taggable_id, :taggable_type]
  end
  
  def self.down
    drop_table :taggings
  end
end
