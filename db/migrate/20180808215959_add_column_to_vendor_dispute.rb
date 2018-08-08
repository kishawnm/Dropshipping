class AddColumnToVendorDispute < ActiveRecord::Migration[5.1]
  def change
    add_column :vendor_disputes, :subject, :string

  end
end
