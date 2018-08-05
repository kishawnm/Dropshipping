class EmailProcessor
  
  def initialize(email)
    @email = email
  end
  
  def process
    
    
    vendor_id=VendorDispute.find_by(email: @email.from[:email])
    if @email.subject.include? vendor_id.order_number
      VendorDisputeMessage.create!({ body: @email.body, email: @email.from[:email], vendor_dispute_id: vendor_id.id })
    end
  end


end