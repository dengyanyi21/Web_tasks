class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.text :content
      t.integer :audit

      t.timestamps
    end
    add_index :comments, :audit
  end
end
