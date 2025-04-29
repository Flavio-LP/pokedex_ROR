require "net/http"
require "json"
require "thread"
require "graphql/client"
require "graphql/client/http"

class PokedexController < ApplicationController
  # Define a query GraphQL
  PokemonQuery = GraphQLClient.parse <<-'GRAPHQL'
    query {
      pokemon_v2_pokemon {
        name
        id
        order
        pokemon_v2_pokemonabilities(distinct_on: pokemon_id) {
          pokemon_v2_pokemon {
            pokemon_v2_pokemontypes(distinct_on: id) {
              pokemon_v2_type {
                name
                id
              }
            }
          }
        }
      }
      pokemon_v2_pokemonsprites {
        id
        sprites
      }
    }
  GRAPHQL

  # @pokedex = []


  def index
    @pokedex = []

   # Executa a query GraphQL

   response = GraphQLClient.query(PokemonQuery)

   if response.data
     # Processa os dados retornados
     pokemons = response.data.pokemon_v2_pokemon
     sprites = response.data.pokemon_v2_pokemonsprites

     pokemons.each_with_index do |pokemon, index|
        types = []
        pokemon.pokemon_v2_pokemonabilities.each do |ability|
          ability.pokemon_v2_pokemon.pokemon_v2_pokemontypes.each do |type_data|
            type_name = type_data.pokemon_v2_type.name
            types << type_name unless types.include?(type_name) # Evita duplicatas
          end
        end


       sprite_data = sprites.find { |sprite| sprite.id == pokemon.id }&.sprites.dig("other", "home", "front_default")
        # sprite_data_shiny = sprites.find { |sprite| sprite.id == pokemon.id }&.sprites.dig("other", "home", "front_shiny")

        sprite_data ||= "https://ih1.redbubble.net/image.3203944270.2367/st,small,507x507-pad,600x600,f8f8f8.jpg"

       @pokedex << {
         name: pokemon.name,
         id: pokemon.id,
         order: pokemon.order,
         sprites: sprite_data,
         # sprites_shiny: sprite_data_shiny,
         types: types
       }
     end

      # Filtra os Pokémon com base na consulta de pesquisa
      if params[:query].present?
        @pokedex.select! { |pokemon| pokemon[:name].downcase.include?(params[:query].downcase) }
      end

      # Ordena o array pelo ID
      @pokedex.sort_by! { |pokemon| pokemon[:id] }
   else
      render json: { error: "Failed to fetch data from GraphQL API" }, status: :bad_request
   end
  end
end
