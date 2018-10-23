class VendorDisputeMessage < ApplicationRecord
  belongs_to :vendor_dispute

  scope :reversed, -> { order 'created_at ASC' }
  
end
