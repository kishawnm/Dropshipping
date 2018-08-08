class EmailProcessor
  
  def initialize(email)
    @email = email
  end
  
  def process
    sub=@email.subject.slice!(0, 2)
    puts '===================='
    puts @email.subject
    puts '===================='
    puts '===================='
    puts '===================='
    puts '===================='
    
    puts sub
    
    
    
    
    vendor_dispute=VendorDispute.find_by(subject: sub)
    puts '===================='

    puts vendor_dispute




    if sub ==vendor_dispute.subject
      VendorDisputeMessage.create!({ body: @email.body, email: @email.from[:email], vendor_dispute_id:vendor_dispute.id })
    end
  end


end