class AddDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string, null: false, default: "BooksAppUser"
    add_column :users, :post_code, :string
    add_column :users, :address, :string
  end
end
