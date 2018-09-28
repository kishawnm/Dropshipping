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
  if params[:order_id].present? && params[:vendor_dispute_id].present?
    @orders = ShopifyAPI::Order.find(params[:order_id])
    @orders=@orders.to_json
    puts "******************"*10
    
    puts "******************"*10
    obj    = JSON.parse(@orders)
    sv2    = obj['fulfillments'].first
    sv1    = obj['fulfillments'].first
    puts "******************"*10
      puts sv2
    puts "******************"*10
    sv1=sv1['tracking_number']
    puts "******************"*10
    puts sv1
    puts "******************"*10
    redirect_to vendors_dashboard_path(id: params[:vendor_dispute_id], tracking_number: sv1)
  else
    @orders = ShopifyAPI::Order.find(params[:order_id])
    @orders=@orders.to_json
    obj    = JSON.parse(@orders)
    sv2    = obj['fulfillments'].first
    sv1    = obj['fulfillments'].first
    sv1=sv1['tracking_number']
    redirect_to vendors_dashboard_path(params[:id])
  end

  end

end


