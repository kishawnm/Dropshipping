class AppUninstalledJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    shop.with_shopify_session do
      puts "#{shop_domain}"*90
    end
  end
end
