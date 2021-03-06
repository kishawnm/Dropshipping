class VendorsDashboardController < ApplicationController
  before_action :set_presets, only: [:show, :index, :create_messages]
  before_action :set_chat, expect: [:customer_issues]
  before_action :set_dispute, only: [:index]
  before_action :set_issues, only: [:index]
  
  def customer_issues
    dispute             = VendorDispute.new
    dispute.vendor_id   = params[:vendor_id]
    dispute.first_name  = params[:first_name]
    dispute.last_name   = params[:last_name]
    dispute.email       = params[:email]
    dispute.order_number= params[:order_number]
    dispute.description = params[:description]
    vendor              = Vendor.find_by_id(params[:vendor_id])
    if vendor && vendor.name.present?
      dispute.subject = "#{vendor.name}-Issue##{params[:order_number]}-#{params[:vendor_id]}"
    else
      dispute.subject = "Order##{params[:order_number]}-#{params[:vendor_id]}"
    end
    if VendorDispute.where(order_number: params[:order_number], vendor_id: params[:vendor_id]).present?
      redirect_to error_message_path
    else
      dispute.save!
      automated_res = AutomatedResponse.where('vendor_id = ? and is_active = ? ', params[:vendor_id], 'true')
      responses = []
      vendor = Vendor.find_by_id(params[:vendor_id])
      if automated_res.present?
        automated_res.each do |res|
          if dispute.description.downcase.include? res.trigger.downcase
            responses << res
          end
        end
      end
      if responses.present?
        @message                  = VendorDisputeMessage.new
        @message.vendor_dispute_id= dispute.id
        @message.body             = responses.last.response
        @message.email            = vendor.email
        @message.save!
        @vendor_dispute=VendorDispute.find_by_id(dispute.id)
        if vendor.name.present?
          UserMailer.with(message: @message, vendor_dispute: @vendor_dispute, name: vendor.name).message_email.deliver_now
        else
          name = vendor.email.split('@').first
          UserMailer.with(message: @message, vendor_dispute: @vendor_dispute, name: name).message_email.deliver_now
        end
      else
        @message                  = VendorDisputeMessage.new
        @message.vendor_dispute_id= dispute.id
        @message.body             = "Thank you for opening dispute.Our team is looking into your issue.We will get back to you soon"
        @message.email            = vendor.email
        @message.save!
        @vendor_dispute=VendorDispute.find_by_id(dispute.id)
        if vendor.name.present?
          UserMailer.with(message: @message, vendor_dispute: @vendor_dispute, name: vendor.name).message_email.deliver_now
        else
          name = vendor.email.split('@').first
          UserMailer.with(message: @message, vendor_dispute: @vendor_dispute, name: name).message_email.deliver_now
        end
      end
    end
  end
  
  def index
    if params[:order].present?
      @order = params[:order]
    end
    @count         = 0
    @response_rate = 0
    if @dispute.present?
      @count    = VendorDisputeMessage.where(vendor_dispute_id: @dispute.id, read: false).where.not(email: current_vendor.email).count
      @messages = VendorDisputeMessage.reversed.where(vendor_dispute_id: @dispute.id)
    
    end
    id = current_vendor.vendor_disputes.pluck(:id)
    @total_unread  = VendorDisputeMessage.where("id IN (?)", id).where(read: false).where.not(email: current_vendor.email).count
    @dispute_count = VendorDispute.where(vendor_id: current_vendor.id).where("DATE(created_at) = ?", Date.today).count
    
    vendor_dispute = VendorDispute.where(vendor_id: current_vendor.id).last
    if vendor_dispute.present?
      customer_message = VendorDisputeMessage.where(vendor_dispute_id: vendor_dispute.id).where(email: current_vendor.email).first
    end
    if vendor_dispute.present? && customer_message.present?
      @response_rate = time_diff(vendor_dispute.created_at, customer_message.created_at).to_i
    end
    @disputes_index = "yes"
  end
  
  def show
    @dispute_id = VendorDispute.find(params[:id])
    req = request.referer
    if req.include?("disputes")
      @issues = VendorDispute.joins(:vendor_dispute_messages).where(vendor_id: current_vendor.id).order(" vendor_dispute_messages.read ASC, vendor_dispute_messages.created_at DESC")
    else
      @issues = VendorDispute.where(vendor_id: current_vendor.id).where("DATE(created_at) = ?", Date.today)
    end
    
    @dispute = VendorDispute.find_by_id(params[:id])
    if @dispute.present?
      VendorDisputeMessage.where(vendor_dispute_id: @dispute.id).update_all(read: true)
      @messages = VendorDisputeMessage.reversed.where(vendor_dispute_id: @dispute.id)
      # respond_to do |format|
      #   format.js
      #   format.html
      # end
    end
    if (params[:tracking_number].present? || params[:created_at].present?) && @dispute.present?
      @tracking_no  = params[:tracking_number]
      @tracking_url = params[:tracking_link]
      @name         = params[:name]
      @fulfilled_at = params[:fulfilled_at]
      @created_at   = params[:created_at]
      @refund_btn = "https://#{current_vendor.email.split("@")[0]}.myshopify.com/admin/orders/#{params[:order_id]}/refund"
      respond_to do |format|
        format.js
        format.html
      end
    elsif params[:status].present?
      
      @status = params[:status]
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
    
    @dispute = VendorDispute.find_by_id(@message.vendor_dispute_id)
    UserMailer.with(message: @message, vendor_dispute: @dispute, name: current_vendor.name).message_email.deliver_now
    
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  def form_editor
    
    if params[:input_fields].present?
      @input_fields = params[:input_fields]
    end
    if VendorPage.where(vendor_id: current_vendor.id).present?
      @anchor_tag = '<a href="'+"https://#{current_vendor.email.split("@")[0]}.myshopify.com/pages/#{VendorPage.where(vendor_id: current_vendor.id).last.shopify_page_handle}"+'" style="position:fixed;right:20px;bottom:25px;"><img id="dispute_form_btn" style="max-width: 35%;float: right;" src="https://cdn.shopify.com/s/files/1/0053/2286/6799/files/Untitled_21.png?10829388671160194190"></a>'
      @js_code = '<script>
      if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
        document.getElementById("dispute_form_btn").style.maxWidth = "35%";
      } else {
        document.getElementById("dispute_form_btn").style.maxWidth = "8%";

      }
      </script>'
      @div = '<header></header>'
      @script = '<script></script>'
    end
    respond_to do |format|
      format.js
      format.html
    end
  
  end

  def contact_us

  end

  def update_dispute
    vendor_dispute = VendorDispute.find(params[:update_order_no][:dispute_id])
    vendor_dispute.order_number = params[:update_order_no][:order_number]
    if vendor_dispute.save
      @status = "Updated successfully"
    else
      @status = "Failed to Updated"
    end
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def time_diff(start_time, end_time)
    seconds_diff = (start_time - end_time).to_i.abs
    
    hours        = seconds_diff / 3600
    seconds_diff -= hours * 3600
    
    minutes      = seconds_diff / 60
    seconds_diff -= minutes * 60
    
    seconds = seconds_diff
    
    "#{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
  end
  
  def set_chat
    @chat = VendorDisputeMessage.new
  end
  
  def set_issues
    @issues = VendorDispute.where(vendor_id: current_vendor.id).where("DATE(created_at) = ?", Date.today).reverse
  end
  
  def set_presets
    @presets = ResponsePreset.all.where(vendor_id: current_vendor.id)
  end
  
  def set_dispute
    @dispute =@issues.first if @issues.present?
  end

end
