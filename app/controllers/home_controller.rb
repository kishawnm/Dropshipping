class HomeController < ShopifyApp::AuthenticatedController
  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @webhooks = ShopifyAPI::Webhook.find(:all)
    # /shop = Shop.find_by(shopify_domain: params[:shop])
    # shop = ShopifyApp::SessionRepository.retrieve(shop.id)
    if params[:shop].present?
      store = params[:shop]
      user_name = store.split(".")[0]
      vend = Vendor.where(store: store)
      if vend.present?
        vend = Vendor.where(store: store).last
        sign_in :vendor, vend
        if current_vendor.present?
          redirect_to vendors_dashboard_index_path
        else
          redirect_to new_vendor_session_path
        end
      else
        vendor = Vendor.new
        vendor.email = "#{user_name}@swirblesolutions.com"
        vendor.password = "#{user_name}"
        vendor.password_confirmation = "#{user_name}"
        vendor.store = store
        if vendor.save
          sign_in :vendor, vendor
          if current_vendor.present?
            redirect_to vendors_dashboard_index_path
          else
            redirect_to new_vendor_session_path
          end
        end
      end
    end
  end

  def get_tracking_status
    require 'rubygems'
    require 'aftership'
    # send order id in params
    puts "*****"*10
    puts params[:order_id]
    puts "*****"*10
    # @orders = ShopifyAPI::Order.find(:all, :params => { :ids => params[:order_id] })
    # @orders = ShopifyAPI::Order.last
    orders = ShopifyAPI::Order.find(:all, params: {limit: 250, page: page})
    order = orders.find { |o| o.order_number == params[:order_id] }
    puts "order details "*10
    puts order
    puts "order details "*10
    # order_details = "#{current_vendor.store}/admin/orders/#{params[:order_id]}.json"
    # pluck tracking id from order_details object
    # tracking_no = order_details[:tracking_id]
    # AfterShip.api_key = 'b00ab653-016a-48d7-9a4a-ae8072e6f41c'
    # AfterShip::V4::Courier.detect({:tracking_number => 'LY517551584CN'})
    # tracking_status = AfterShip::V4::Tracking.get('ups', "LY517551584CN")
    # puts tracking_status
    # get tracking status from tracking_status object
    redirect_to vendors_dashboard_index_path(order: order)
  end

end
