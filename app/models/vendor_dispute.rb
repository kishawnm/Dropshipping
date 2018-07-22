class VendorDispute < ApplicationRecord
  belongs_to :vendor
  has_many :vendor_dispute_messages
end
