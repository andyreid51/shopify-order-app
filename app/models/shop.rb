# frozen_string_literal: true

class Shop < ActiveRecord::Base
  include ShopifyApp::ShopSessionStorageWithScopes

  def api_version
    ShopifyApp.configuration.api_version
  end

  def self.system
    new(
      shopify_domain: ENV.fetch('SHOPIFY_DOMAIN', '').presence,
      shopify_token: ENV.fetch('SHOPIFY_CUSTOM_APP_ACCESS_TOKEN', '').presence
    )
  end
end
