class CreateVendorDisputeMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :vendor_dispute_messages do |t|
      t.integer :vendor_dispute_id
      t.text :body
      t.string :email

      t.timestamps
    end
  end
end
