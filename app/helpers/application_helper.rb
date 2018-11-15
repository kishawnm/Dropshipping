module ApplicationHelper
  
  def vendor_name
    current_vendor.name
  end
  
  def notifications
    VendorDispute.joins(:vendor_dispute_messages).where(vendor_id: current_vendor.id).where("vendor_dispute_messages.read", false).uniq
  end
  
  def messages_count
    id = current_vendor.vendor_disputes.pluck(:id)
    VendorDisputeMessage.where("id IN (?)", id).where(read: false).where.not(email: current_vendor.email).count
  end
end
