class Vendor < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :vendor_disputes



  def unread_message
    count=0
    a.vendor_disputes.each  do |v|
     count += v.vendor_dispute_messages.where(read:false)
    
      
    end
    
    self.vendor_disputes.vendor_dispute_messages.where(read:false)
    
  end


end
