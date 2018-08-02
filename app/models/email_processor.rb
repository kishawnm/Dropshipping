class EmailProcessor
  
  def initialize(email)
    @email = email
  end
  
  
  
  def self.process(email)
    VendorDisputeMessage.create!({ body: email.body, email: email.from })
  end
end