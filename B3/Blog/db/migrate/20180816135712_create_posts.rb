class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.text :content
      t.string :category
      t.integer :audit

      t.timestamps
    end
    add_index :posts, :category
    add_index :posts, :created_at
    add_index :posts, :audit
  end
end
