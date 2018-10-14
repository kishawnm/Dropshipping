class AddReadToVendorDisputeMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :vendor_dispute_messages, :read, :boolean, default: false
  end
end
