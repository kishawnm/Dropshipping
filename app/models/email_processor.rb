class EmailProcessor
  
  def initialize(email)
    @email = email
  end
  
  def process
    vendor_id=VendorDispute.find_by(email: email.from)
    VendorDisputeMessage.create!({ body: @email.body, email: @email.from, vendor_dispute_id: vendor_id.id })
  end
  
  # #
  #
  #
  # def self.process(email)
  #   VendorDisputeMessage.create!({ body: email.body, email: email.from })
  # end
end