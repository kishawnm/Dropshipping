class VendorsDashboardController < ApplicationController
  before_action :set_presets, expect: [:customer_issues, :form_editor]
  before_action :set_chat, expect: [:customer_issues]
  before_action :set_dispute, only: [:create_messages, :index]
  before_action :set_issues, only: [:index, :show]
  
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
    if params[:order].present?
      @order = params[:order]
      @dispute_count= VendorDispute.where(vendor_id:current_vendor.id,created_at:Date.today )
    end
    if @dispute.present?
      @messages =VendorDisputeMessage.where(vendor_dispute_id: @dispute.id)
      @count =VendorDisputeMessage.where(vendor_dispute_id: @dispute.id, read:false).where.not(email: current_vendor.email).count
    end
    id = current_vendor.vendor_disputes.pluck(:id)
      @total_unread = VendorDisputeMessage.where("id IN (?)", id).where.not(read: true)
  end
  
  def show
    @dispute = VendorDispute.find_by_id(params[:id])
    
    if params[:tracking_number].present? && @dispute.present?
      @tracking_no = params[:tracking_number]
      @tracking_url=params[:tracking_link]
      @messages    = VendorDisputeMessage.where(vendor_dispute_id: @dispute.id)
      @messages
      respond_to do |format|
        format.js
        format.html
      end
    elsif params[:status].present?
      @messages = VendorDisputeMessage.where(vendor_dispute_id: @dispute.id).update_all(read:true)
      @status   = params[:status]
      respond_to do |format|
        format.js
        format.html
      end
    
    else
      redirect_to get_tracking_status_path(order_id: @dispute.order_number, vendor_dispute_id: params[:id])
    end
  
  end
  
  
  def create_messages
    @message                   = VendorDisputeMessage.new
    @message.vendor_dispute_id = params[:vendor_dispute_message][:vendor_dispute_id]
    @message.body              = params[:vendor_dispute_message][:body]
    @message.email             = params[:vendor_dispute_message][:email]
    @message.save!
    @messages = VendorDisputeMessage.where(vendor_dispute_id: @message.vendor_dispute_id)
    
    @vendor_dispute = VendorDispute.find_by_id(@message.vendor_dispute_id)
    UserMailer.with(message: @message, vendor_dispute: @vendor_dispute).message_email.deliver_now
    
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  def form_editor
    
    if params[:input_fields].present?
      @input_fields = params[:input_fields]
    end
    respond_to do |format|
      format.js
      format.html
    end
  
  end
  
  
  private
  
  def set_chat
    @chat = VendorDisputeMessage.new
  end
  
  def set_issues
    @issues = VendorDispute.where(vendor_id: current_vendor.id)
  end
  
  def set_presets
    @presets = ResponsePreset.all.where(vendor_id: current_vendor.id)
  end
  
  def set_dispute
    @dispute=VendorDispute.find_by(vendor_id: current_vendor.id)
  end

end
