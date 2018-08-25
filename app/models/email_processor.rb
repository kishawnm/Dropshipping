class EmailProcessor
  
  def initialize(email)
    @email = email
  end
  
  def process
    @email.subject.slice!(0, 4)
    puts '===================='
    puts @email.subject
    puts '===================='
    puts '===================='
    puts '===================='
    puts '===================='
    sub=@email.subject
    puts sub
    vendor_dispute=VendorDispute.find_by(subject: sub)
    puts '===================='
    puts vendor_dispute
    if sub ==vendor_dispute.subject
      VendorDisputeMessage.create!({ body: @email.body, email: @email.from[:email], vendor_dispute_id:vendor_dispute.id })
      automated_res=AutomatedResponse.where(vendor_id: vendor_dispute.vendor_id)
      automated_res.each do |res|
        if @email.body.downcase.include? res.trigger.downcase
          @message                  =VendorDisputeMessage.new
          @message.vendor_dispute_id=vendor_dispute.id
          @message.body             =res.response
          @message.email            = vendor_dispute.email
          @message.save!
          @vendor_dispute=VendorDispute.find_by_id(vendor_dispute.id)
          UserMailer.with(message: @message, vendor_dispute: @vendor_dispute).message_email.deliver_now
        end
      end
      
      
    end
    
    
    
  end


end