class VendorDispute < ApplicationRecord
  # validates :order_number, uniqueness: {:scope=>:vendor_id}
  # validates :order_number, uniqueness: true, if: :uniq_order_number
  belongs_to :vendor
  has_many :vendor_dispute_messages
  
  def self.search(search,id)
    if search.blank?  # blank? covers both nil and empty string
      all
    else
      where('vendor_id = ? and order_number LIKE ?', id ,"%#{search}%")
    end
  end


end
