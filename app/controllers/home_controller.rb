class HomeController < ShopifyApp::AuthenticatedController
  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @webhooks = ShopifyAPI::Webhook.find(:all)
    # /shop = Shop.find_by(shopify_domain: params[:shop])
    # shop = ShopifyApp::SessionRepository.retrieve(shop.id)
    if params[:shop].present?
      store     = params[:shop]
      user_name = store.split(".")[0]
      vend      = Vendor.where(store: store)
      if vend.present?
        vend = Vendor.where(store: store).last
        sign_in :vendor, vend
        if current_vendor.present?
          redirect_to vendors_dashboard_index_path
        else
          redirect_to new_vendor_session_path
        end
      else
        vendor                       = Vendor.new
        vendor.email                 = "#{user_name}@swirblesolutions.com"
        vendor.password              = "#{user_name}"
        vendor.password_confirmation = "#{user_name}"
        vendor.store                 = store
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
    require 'json'
    # send order id in params
    # @orders = ShopifyAPI::Order.find(:all, :params => { :ids => params[:order_id] })
    @orders = ShopifyAPI::Order.find(params[:order_id])
    @orders=@orders.to_json
    obj    = JSON.parse(@orders)
    sv2    = obj['fulfillments'].first
    sv1    = obj['fulfillments'].first
    sv1=sv1['tracking_number']

    # puts sv2
    # order_details = "#{current_vendor.store}/admin/orders/#{params[:order_id]}.json"
    # pluck tracking id from order_details object
    # tracking_no = order_details[:tracking_id]
    AfterShip.api_key = 'dfbe0470-2867-427d-b534-408db77f4cde'
    # tracking_status1  = AfterShip::V4::Tracking.get.({ :tracking_number => sv1 })
    tracking_status  = AfterShip::V4::Courier.detect({ :tracking_number => 'LY517551584CN' })
    tracking_status1   = AfterShip::V4::Tracking.get('kronos',sv1)
    tracking_status2   = AfterShip::V4::Tracking.get('sfcservice',sv1)
    tracking_status3   = AfterShip::V4::Tracking.get('cnexps',sv1)
    tracking_status4   = AfterShip::V4::Tracking.get('china-ems',sv1)
    # puts tracking_status
    puts "*****"*10
    puts sv2
    puts tracking_status
    puts tracking_status1
    puts tracking_status2
    puts tracking_status3
    puts tracking_status4
    puts "*****"*10

    # get tracking status from tracking_status object
    redirect_to vendors_dashboard_index_path
  end

end


