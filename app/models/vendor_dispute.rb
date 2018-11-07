class VendorDispute < ApplicationRecord
  # validates :order_number, uniqueness: {:scope=>:vendor_id}
  # validates :order_number, uniqueness: true, if: :uniq_order_number
  belongs_to :vendor
  has_many :vendor_dispute_messages
  
  def self.search(search,id)
    if search.blank?  # blank? covers both nil and empty string
      all
    else
      where('vendor_id = :id and first_name  LIKE :search OR last_name LIKE :search OR order_number LIKE :search',id: id ,search: "%#{search}%")
    end
  end
end
