class DisputesController < ApplicationController
  
  def index
    @disputed_result = VendorDispute.search(params[:search],current_vendor.id)
    if @disputed_result.present?
      @issues = @disputed_result
    else
      @issues = VendorDispute.joins(:vendor_dispute_messages).where(vendor_id: current_vendor.id).order(" vendor_dispute_messages.read ASC, vendor_dispute_messages.created_at DESC")
    end
    @dispute = @issues.first
    if @dispute.present?
      @messages = VendorDisputeMessage.reversed.where(vendor_dispute_id: @dispute.id)
    end
    @chat     = VendorDisputeMessage.new
    @presets  = ResponsePreset.all.where(vendor_id: current_vendor.id)
  end
end
