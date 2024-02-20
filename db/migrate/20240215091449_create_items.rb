class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :price
      t.string :rakuten_url
      t.string :image
      t.string :item_code, null: false

      t.timestamps
    end
  end
end
