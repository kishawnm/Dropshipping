class VendorsDashboardController < ApplicationController
  include ShopifyApp::AuthenticatedController
  def customer_issues
    dispute             =VendorDispute.new
    dispute.vendor_id   =params[:vendor_id]
    dispute.first_name  =params[:first_name]
    dispute.last_name   =params[:last_name]
    dispute.email       =params[:email]
    dispute.order_number=params[:order_number]
    dispute.description =params[:description]
    dispute.subject     ='Issue#'+params[:order_number] + '-'+params[:vendor_id]
    unless VendorDispute.where(order_number: params[:order_number], vendor_id: params[:vendor_id]).present?
      dispute.save!
      automated_res=AutomatedResponse.where(vendor_id: params[:vendor_id])
      vendor       =Vendor.find_by_id(params[:vendor_id])
      automated_res.each do |res|
        if dispute.description.downcase.include? res.trigger.downcase
          @message                  =VendorDisputeMessage.new
          @message.vendor_dispute_id=dispute.id
          @message.body             =res.response
          @message.email            = vendor.email
          @message.save!
          @vendor_dispute=VendorDispute.find_by_id(dispute.id)
          UserMailer.with(message: @message, vendor_dispute: @vendor_dispute).message_email.deliver_now
        end
      end
    else
      redirect_to error_message_path
    end
  end
  
  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @orders = ShopifyAPI::Order.find(551509033056)
    @dispute=VendorDispute.find_by(vendor_id: current_vendor.id)
    @issues =VendorDispute.where(vendor_id: current_vendor.id)
    @presets=ResponsePreset.all.where(vendor_id: current_vendor.id)
    if @dispute.present?
      @messages=VendorDisputeMessage.where(vendor_dispute_id: @dispute.id)
    end
    @chat =VendorDisputeMessage.new
  
  end
  
  def show
    @issues  =VendorDispute.where(vendor_id: current_vendor.id)
    @presets =ResponsePreset.all.where(vendor_id: current_vendor.id)
    @dispute =VendorDispute.find_by_id(params[:id])
    @messages=VendorDisputeMessage.where(vendor_dispute_id: @dispute.id)
    @chat    =VendorDisputeMessage.new
    respond_to do |format|
      format.js
      format.html
    end
  
  end
  
  
  def create_messages
    @chat   =VendorDisputeMessage.new
    @presets=ResponsePreset.all.where(vendor_id: current_vendor.id)
    @dispute=VendorDispute.find_by(vendor_id: current_vendor.id)
    
    @message                  =VendorDisputeMessage.new
    @message.vendor_dispute_id=params[:vendor_dispute_message][:vendor_dispute_id]
    @message.body             =params[:vendor_dispute_message][:body]
    @message.email            =params[:vendor_dispute_message][:email]
    @message.save!
    @messages=VendorDisputeMessage.where(vendor_dispute_id: @message.vendor_dispute_id)
    
    @vendor_dispute=VendorDispute.find_by_id(@message.vendor_dispute_id)
    UserMailer.with(message: @message, vendor_dispute: @vendor_dispute).message_email.deliver_now
    
    respond_to do |format|
      format.js
      format.html
    end
  end
end
