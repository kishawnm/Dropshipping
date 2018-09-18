class HomeController < ShopifyApp::AuthenticatedController
  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @webhooks = ShopifyAPI::Webhook.find(:all)
    if current_vendor.present?
      redirect_to vendors_dashboard_index_path
    else
      redirect_to new_vendor_session_path
    end
  end
end
