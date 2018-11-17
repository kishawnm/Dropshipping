class CreateVendorPages < ActiveRecord::Migration[5.1]
  def change
    create_table :vendor_pages do |t|
      t.integer :shopify_page_id
      t.string :shopify_page_handle
      t.string :shopify_page_title
      t.integer :vendor_id

      t.timestamps
    end
  end
end
