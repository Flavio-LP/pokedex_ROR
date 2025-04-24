require 'net/http'
require 'json'
require 'thread'
require 'graphql/client'
require 'graphql/client/http'

class PokedexController < ApplicationController
  # Define a query GraphQL
  PokemonQuery = GraphQLClient.parse <<-'GRAPHQL'
    query {
      pokemon_v2_pokemon {
        name
        id
        order
      }
      pokemon_v2_pokemonsprites {
        id  
        sprites
      }
    }
  GRAPHQL

  def index
    @pokedex = []

    # Executa a query GraphQL

   response = GraphQLClient.query(PokemonQuery)

   if response.data
     # Processa os dados retornados
     pokemons = response.data.pokemon_v2_pokemon
     sprites = response.data.pokemon_v2_pokemonsprites

     pokemons.each_with_index do |pokemon, index|

       sprite_data = sprites.find { |sprite| sprite.id == pokemon.id }&.sprites.dig("other", "home", "front_default")

       @pokedex << {
         name: pokemon.name,
         id: pokemon.id,
         order: pokemon.order,
         sprites: sprite_data
       }
     end

      # Ordena o array pelo ID
      @pokedex.sort_by! { |pokemon| pokemon[:id] }
    else
      render json: { error: "Failed to fetch data from GraphQL API" }, status: :bad_request
    end
  end
end