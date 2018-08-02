class EmailProcessor
  
  def initialize(email)
    @email = email
  end

  def process
      # binding.pry
    VendorDisputeMessage.create!({ body: @email.body, email: @email.from })
  end

  # #
  #
  #
  # def self.process(email)
  #   VendorDisputeMessage.create!({ body: email.body, email: email.from })
  # end
end