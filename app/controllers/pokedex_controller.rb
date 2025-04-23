require 'net/http'
require 'json'
require 'thread'

class PokedexController < ApplicationController

    def index 
        @pokedex = []

        # Busca os primeiros 1000 Pokémon
        pokemons = request_pokemon("https://pokeapi.co/api/v2/pokemon?offset=0&limit=1000") # Limita a 1000 Pokémon

        threads = []
        mutex = Mutex.new

        pokemons["results"].each do |pokemon|
            threads << Thread.new do
                name = pokemon["name"]
                pokemon_data = request_pokemon(pokemon["url"])
                sprites = pokemon_data["sprites"]

                pokemon_entry = {
                    name: name,
                    id: pokemon_data["id"],
                    height: pokemon_data["height"],
                    weight: pokemon_data["weight"],
                    types: pokemon_data["types"].map { |type| type["type"]["name"] },
                    sprites: {
                        front_default: sprites["front_default"]
                    }
                }

                # Adiciona ao array de forma segura
                mutex.synchronize { @pokedex << pokemon_entry }
            end

            # Limita o número de threads simultâneas para evitar sobrecarga
            if threads.size >= 80
                threads.each(&:join)
                threads.clear
            end
        end

        # Aguarda todas as threads restantes terminarem
        threads.each(&:join)

        @pokedex.sort_by! { |pokemon| pokemon[:id] }
    end

    def request_pokemon(url)
        Rails.cache.fetch(url, expires_in: 12.hours) do
            response = Net::HTTP.get(URI(url))
            JSON.parse(response)
        end
    end

end