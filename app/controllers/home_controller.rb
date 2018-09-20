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
        vendor.email = "#{user_name}@example.com"
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
    # require 'rubygems'
    # require 'aftership'
    # send order id in params
    @orders = ShopifyAPI::Order.find(params[:order_id])
    redirect_to vendors_dashboard_index_path(order: @orders)
    # order_details = "#{current_vendor.store}/admin/orders/#{params[:order_id]}.json"
    # pluck tracking id from order_details object
    # tracking_no = order_details[:tracking_id]
    # AfterShip.api_key = 'b00ab653-016a-48d7-9a4a-ae8072e6f41c'
    # tracking_status = AfterShip::V4::Tracking.get('ups', tracking_no)
    # get tracking status from tracking_status object
  end

end
