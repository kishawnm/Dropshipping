class EmailProcessor
  
  def initialize(email)
    @email = email
  end
  
  def process
    # all of your code to deal with the email goes here
  end
  
  
  
  
  def self.process(email)
    VendorDisputeMessage.create!({ body: email.body, email: email.from })
  end
end