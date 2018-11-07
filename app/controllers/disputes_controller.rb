class DisputesController < ApplicationController
  
  def index
    if params[:search].present?
      @issues = VendorDispute.search(params[:search],current_vendor.id)
    else
      @issues = VendorDispute.joins(:vendor_dispute_messages).where(vendor_id: current_vendor.id).order(" vendor_dispute_messages.read ASC, vendor_dispute_messages.created_at DESC").uniq
    end
    @dispute = @issues.first
    if @dispute.present?
      @messages = VendorDisputeMessage.reversed.where(vendor_dispute_id: @dispute.id)
    end
    @chat     = VendorDisputeMessage.new
    @presets  = ResponsePreset.all.where(vendor_id: current_vendor.id)
  end
end
