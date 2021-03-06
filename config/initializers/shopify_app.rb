ShopifyApp.configure do |config|
  config.application_name       = "Drop Shipping"
  config.api_key                = "c4cb3a84ba5ba3f28e147ca9d8c110e6"
  config.secret                 = "e86e8600ddd3d2326d3ca03818ae34a2"
  config.scope                  = "read_orders, read_products, read_all_orders, read_content, write_content"
  config.embedded_app           = true
  config.after_authenticate_job = false
  config.session_repository     = Shop
  config.webhooks = [
    {topic: 'app/uninstalled', address: 'https://www.swirblesolutions.com/home/app_uninstalled', format: 'json'}
  ]
end
