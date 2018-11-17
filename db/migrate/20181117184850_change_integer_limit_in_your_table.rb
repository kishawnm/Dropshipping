class ChangeIntegerLimitInYourTable < ActiveRecord::Migration[5.1]
  def change
    change_column :vendor_pages, :shopify_page_id, :integer, limit: 8
  end
end
