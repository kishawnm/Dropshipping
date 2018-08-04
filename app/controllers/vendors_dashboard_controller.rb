class VendorsDashboardController < ApplicationController
  
  def customer_issues
    dispute             =VendorDispute.new
    dispute.vendor_id   =params[:vendor_id]
    dispute.first_name  =params[:first_name]
    dispute.last_name   =params[:last_name]
    dispute.email       =params[:email]
    dispute.order_number=params[:order_number]
    dispute.description =params[:description]
    dispute.save!
  end
  
  def index
    @dispute=VendorDispute.find_by(vendor_id: current_vendor.id)
    @issues =VendorDispute.where(vendor_id: current_vendor.id)
    @presets=ResponsePreset.all.where(vendor_id: current_vendor.id)
    @chat   =VendorDisputeMessage.new
  
  end
  
  def show
    @issues =VendorDispute.where(vendor_id: current_vendor.id)
    @presets=ResponsePreset.all.where(vendor_id: current_vendor.id)
    @dispute=VendorDispute.find_by_id(params[:id])
    @chat   =VendorDisputeMessage.new
    respond_to do |format|
      format.js
      format.html
    end
  
  end
  
  
  def create_messages
    @message                  =VendorDisputeMessage.new
    @message.vendor_dispute_id=params[:vendor_dispute_message][:vendor_dispute_id]
    @message.body             =params[:vendor_dispute_message][:body]
    @message.email            =params[:vendor_dispute_message][:email]
    @message.save!
    @vendor_dispute=VendorDispute.find_by_id(@message.vendor_dispute_id)
    UserMailer.with(message: @message,vendor_dispute:@vendor_dispute).message_email.deliver_now
  
  end
end
