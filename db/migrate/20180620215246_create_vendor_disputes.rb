class CreateVendorDisputes < ActiveRecord::Migration[5.1]
  def change
    create_table :vendor_disputes do |t|
      t.integer :vendor_id
      t.string :first_name
      t.string :last_name
      t.string :order_number
      t.text :description

      t.timestamps
    end
  end
end
