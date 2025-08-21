class GetProduct
  include ShopifyGraphql::Query

  QUERY = <<~GRAPHQL
    query($id: ID!) {
      product(id: $id) {
        handle
        title
        description
      }
    }
  GRAPHQL

  def call(id:)
    response = execute(QUERY, id: id)
    response.data = response.data.product
    response
  end
end