class GetProducts
  include ShopifyGraphql::Query

  QUERY = <<~GRAPHQL
    query {
      products(first: 5) {
        edges {
          node {
            id
            title
            featuredImage {
              source: url
            }
          }
        }
      }
    }
  GRAPHQL

  def call
    response = execute(QUERY)
    response.data = parse_data(response.data.products.edges)
    response
  end

  private

  def parse_data(data)
    return [] if data.blank?

    data.compact.map do |edge|
      OpenStruct.new(
        id: edge.node.id,
        title: edge.node.title,
        featured_image: edge.node.featuredImage&.source
      )
    end
  end
end