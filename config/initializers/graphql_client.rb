require 'graphql/client'
require 'graphql/client/http'

# Substitua pela URL do endpoint GraphQL da API
HTTP = GraphQL::Client::HTTP.new("https://beta.pokeapi.co/graphql/v1beta") do
  def headers(context)
    { "Content-Type" => "application/json" }
  end
end

# Schema do GraphQL
Schema = GraphQL::Client.load_schema(HTTP)
GraphQLClient = GraphQL::Client.new(schema: Schema, execute: HTTP)