# frozen_string_literal: true

class HomeController < ApplicationController
  include ShopifyApp::EmbeddedApp
  include ShopifyApp::EnsureInstalled
  include ShopifyApp::ShopAccessScopesVerification

  def index

    

    if ShopifyAPI::Context.embedded? && (!params[:embedded].present? || params[:embedded] != "1")
      redirect_to(ShopifyAPI::Auth.embedded_app_url(params[:host]) + request.path, allow_other_host: true)
    else
      @shop_origin = current_shopify_domain
      @host = params[:host]
    end

    @graphql = params[:graphql] == "true"
    if @graphql
      @products = GetProducts.call.data
    else
      @products = ShopifyAPI::Product.all(limit: 10)
    end

    # https://github.com/Shopify/shopify_app/blob/main/docs/shopify_app/sessions.md
    current_session = installed_shop_session # `installed_shop_session` is a helper from `EnsureInstalled`
    client = ShopifyAPI::Clients::Graphql::Admin.new(session: current_session)

    query =<<~QUERY
      {
        products(first: 5) {
          edges {
            cursor
            node {
              id
              title
              onlineStoreUrl
            }
          }
        }
      }
    QUERY

    response = client.query(query: query)
    @product = response.body["data"]["products"]["edges"][0]
    # @graph_products = response.body["data"]["products"]["edges"]
    # @products = response.body["data"]["products"]["edges"].map(&:node)
    @access_token = current_session.access_token
    # shpua_39f773883729088926150c073336f668

    Shop.system.with_shopify_session do
      @product_gql = GetProduct.call(id: "gid://shopify/Product/7763256672374").data
    end

    Shop.system.with_shopify_session do
      @graph_products = GetProducts.call.data
    end
  end
end
