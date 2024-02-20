class CreatePostItems < ActiveRecord::Migration[6.0]
  def change
    create_table :post_items do |t|
      t.references :post, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
    add_index :post_items, [:post_id, :item_id], unique: true
  end
end
