class VendorDispute < ApplicationRecord
  validates :order_number, uniqueness: true
  belongs_to :vendor
  has_many :vendor_dispute_messages
end
