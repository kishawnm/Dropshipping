class VendorDispute < ApplicationRecord
  # validates :order_number, uniqueness: {:scope=>:vendor_id}
  # validates :order_number, uniqueness: true, if: :uniq_order_number
  belongs_to :vendor
  has_many :vendor_dispute_messages

  

end
