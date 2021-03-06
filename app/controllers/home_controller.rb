class HomeController < ShopifyApp::AuthenticatedController
  protect_from_forgery with: :null_session

  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @webhooks = ShopifyAPI::Webhook.find(:all)
    # shop = Shop.find_by(shopify_domain: params[:shop])
    # shop = ShopifyApp::SessionRepository.retrieve(shop.id)
    # require 'rest_client'
    # require 'json'
    #
    # revoke_url   = "https://usamastore12.myshopify.com/admin/pages.json"
    #
    # headers = {
    #     'X-Shopify-Access-Token' => @shop_session.token,
    #     content_type: 'application/json',
    #     accept: 'application/json'
    # }
    # payload = '{ "page": { "title":"Contact us", "body_html":"<h2>Warranty</h2>\n<p>Returns accepted if we receive items <strong>30 days after purchase</strong>.</p>"} }'
    # response =  RestClient.post(revoke_url, payload, headers)
    # puts "response"*response.code # 200 for success
    # puts JSON.parse(response)
    # access_token = "#{params[:hmac]}"
    # revoke_url   = "https://usamastore12.myshopify.com/admin/webhooks.json"
    #
    # headers = {
    #     'X-Shopify-Access-Token' => @shop_session.token,
    #     content_type: 'application/json',
    #     accept: 'application/json'
    # }
    # payload = {
    #     "webhook": {
    #         "topic": "orders/create",
    #         "address": "https://whatever.hostname.com/",
    #         "format": "json"
    #     }
    # }
    # response =  RestClient.post(revoke_url, payload, headers)
    # puts "response"*response.code # 200 for success
    if params[:shop].present?
      store     = params[:shop]
      user_name = store.split(".")[0]
      vend      = Vendor.where(store: store)
      if vend.present?
        vend = Vendor.where(store: store).last
        sign_in :vendor, vend
        if current_vendor.present? && current_vendor.sign_in_count > 1
          redirect_to vendors_dashboard_index_path
        elsif current_vendor.sign_in_count <=1
          flash[:notice] = 'Please enter your name'
          redirect_to edit_vendor_registration_path
        else
          redirect_to new_vendor_session_path
        end
      else
        vendor                       = Vendor.new
        vendor.name                  = user_name
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
          orders          = ShopifyAPI::Order.find(:all, :params => { :name => "##{params[:order_id]}", :status => 'any', :limit => 250 }).last
          orders          = orders.to_json
          obj             = JSON.parse(orders)
          sv1             = obj['fulfillments'].first if obj['fulfillments'].present?
          puts '********'*100
          puts obj
          puts "sv1"
          puts sv1
          puts obj['email']
          puts '********'*100
          email = obj['email'] if obj.present?
          tracking_number = sv1['tracking_number'] if sv1.present?
          tracking_link   = sv1['tracking_url'] if sv1.present?
          fulfilled_at    = sv1['created_at'] if sv1.present?
          address         = obj['billing_address'] if obj.present?
          order_id = obj['id']  if obj.present?
          if address.present?
            name = address['name']
          else
            name= 'not available'
          end
          
          if fulfilled_at.present?
          else
            fulfilled_at = 'Order is not fulfilled yet '
          end
            created_at = obj['created_at']
          
          if tracking_number.nil? && tracking_link.nil?
            status = "Order is not fulfilled yet"
          end
          redirect_to vendors_dashboard_path(id: params[:vendor_dispute_id], tracking_number: tracking_number, tracking_link: tracking_link, fulfilled_at: fulfilled_at, name: name, created_at: created_at, status: status, email:email, order_id: order_id)
        else
          status='Dispute Order no is not valid'
          redirect_to vendors_dashboard_path(id: params[:vendor_dispute_id], status: status)
        end
      rescue ActiveResource::ResourceNotFound
        status='Dispute Order no is not valid'
        redirect_to vendors_dashboard_path(id: params[:vendor_dispute_id], status: status)
      end
    
    else
      redirect_to vendors_dashboard_path(params[:id])
    end
  
  end

  def add_to_store
    require 'rest_client'
    require 'json'
    revoke_url   = "https://#{current_vendor.email.split("@")[0]}.myshopify.com/admin/pages.json"

    headers = {
        'X-Shopify-Access-Token' => @shop_session.token,
        content_type: 'application/json',
        accept: 'application/json'
    }
    payload = { "page": { "title":"Contact us", "body_html":"#{params[:code]}"} }
    response =  RestClient.post(revoke_url, payload, headers)
    puts "response"*response.code # 200 for success
    puts JSON.parse(response)
    obj =  JSON.parse(response)
    if VendorPage.where(vendor_id: current_vendor.id).present?
      # do nothing
    else
      VendorPage.create(vendor_id: current_vendor.id, shopify_page_id: obj['page']['id'],shopify_page_handle: obj['page']['handle'], shopify_page_title: obj['page']['title'])
    end
  end


  def update_to_store
    require 'rest_client'
    require 'json'
    @page = VendorPage.where(vendor_id: current_vendor.id).last
    revoke_url   = "https://#{current_vendor.email.split("@")[0]}.myshopify.com/admin/pages/#{@page.shopify_page_id}.json"

    headers = {
        'X-Shopify-Access-Token' => @shop_session.token,
        content_type: 'application/json',
        accept: 'application/json'
    }
    payload = { "page": { "id":"#{@page.shopify_page_id}", "body_html":"#{params[:code]}"} }
    response =  RestClient.put(revoke_url, payload, headers)
    puts "response"*response.code # 200 for success
    puts JSON.parse(response)
    obj =  JSON.parse(response)
    @page.update_attributes(vendor_id: current_vendor.id, shopify_page_id: obj['page']['id'],shopify_page_handle: obj['page']['handle'], shopify_page_title: obj['page']['title'])
  end

  def app_uninstalled
    # puts "params"*10
    # email = "#{params[:name]}@swirblesolutions.com"
    # vendor = Vendor.where(email: email)
    # if vendor.present? && vendor.last.sign_in_count > 0
    #    vendor.last.destroy
    # end
    puts "webhook is running"*90
  end

end


