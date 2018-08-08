class EmailProcessor
  
  def initialize(email)
    @email = email
  end
  
  def process
    
    vendor_dispute=VendorDispute.find_by(subject: @email.subject[:subject])
    if @email.subject[:subject] ==vendor_dispute.subject
      VendorDisputeMessage.create!({ body: @email.body, email: @email.from[:email], vendor_dispute_id:vendor_dispute.id })
    end
  end


end