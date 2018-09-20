class AddStoreToVendor < ActiveRecord::Migration[5.1]
  def change
    add_column :vendors, :store, :string
  end
end
