class AddEmailToVendorDispute < ActiveRecord::Migration[5.1]
  def change
    add_column :vendor_disputes, :email, :string
  end
end
