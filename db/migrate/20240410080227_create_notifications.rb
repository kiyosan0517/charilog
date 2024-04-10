class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :notification_type
      t.text :content
      t.datetime :sent_at
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
