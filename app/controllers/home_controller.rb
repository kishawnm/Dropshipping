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
      begin
        orders = ShopifyAPI::Order.find(:all, :params => { :name => "##{params[:order_id]}", :status => 'any', :limit => 250 })
        if orders.present?
          orders = ShopifyAPI::Order.find(:all, :params => { :name => "##{params[:order_id]}", :status => 'any', :limit => 250 }).last
          orders = orders.to_json
          obj    = JSON.parse(orders)
          sv1    = obj['fulfillments'].first
          
          tracking_number = sv1['tracking_number']
          tracking_link   = sv1['tracking_url']
          fulfilled_at    = sv1['created_at']
          address         = obj['billing_address']
          if address.present?
            name = address['name']
          end
          created_at = obj['created_at']
          
          redirect_to vendors_dashboard_path(id: params[:vendor_dispute_id], tracking_number: tracking_number, tracking_link: tracking_link, fulfilled_at: fulfilled_at, name: name, created_at: created_at)
        else
          status='Please enter valid order number'
          redirect_to vendors_dashboard_path(id: params[:vendor_dispute_id], status: status)
        end
      rescue ActiveResource::ResourceNotFound
        status='Please enter valid order number'
        redirect_to vendors_dashboard_path(id: params[:vendor_dispute_id], status: status)
      end
    
    else
      redirect_to vendors_dashboard_path(params[:id])
    end
  
  end

end


