class DisputesController < ApplicationController
  
  def index
    @issues = VendorDispute.where(vendor_id: current_vendor.id)
    @dispute=@issues.first
    if @dispute.present?
      @messages = VendorDisputeMessage.reversed.where(vendor_dispute_id: @dispute.id)
    end
    @chat     = VendorDisputeMessage.new
    @presets  = ResponsePreset.all.where(vendor_id: current_vendor.id)
  end
  
end
