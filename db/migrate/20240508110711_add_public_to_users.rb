class AddPublicToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :public, :boolean, default: true
  end
end
