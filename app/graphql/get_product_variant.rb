class GetProductVariant
  include ShopifyGraphql::Query

  QUERY = <<~GRAPHQL
    query ($id: ID!) {
      productVariant(id: $id) {
        id
        title
        sku
        price
        inventoryQuantity
        product {
          id
          title
        } 

      }
    }
  GRAPHQL

  def call(id:)
    response = execute(QUERY, id: id)
    response.data = parse_data(response.data.productVariant)
    response
  end

  private

  def parse_data(data)

      OpenStruct.new(
        id: data.id,
        title: "#{data.product&.title} / #{data.title}",
        product_title: data.product&.title
      )

  end
end