# Pokédex Ruby on Rails

Este projeto é uma aplicação web construída com **Ruby on Rails** que implementa uma Pokédex, permitindo que os usuários visualizem informações detalhadas sobre Pokémon, como nome, ID, tipos e sprites (imagens). A aplicação utiliza a **PokéAPI** via GraphQL para buscar os dados dos Pokémon e exibi-los de forma interativa.

---

## Funcionalidades

- **Listagem de Pokémon**: Exibe uma lista de Pokémon com informações como nome, imagem e passando o pointer em cima da imagem, é disponibilizado o tipo do Pokémon.
- **Barra de Pesquisa**: Permite buscar Pokémon pelo nome ou typos disponíveis.
- **Ordenação**: Os Pokémon são ordenados sequencialmente pelo ID.
- **Exibição de Tipos**: Mostra os tipos de cada Pokémon.
- **Fallback para Imagens**: Caso uma imagem não esteja disponível, uma imagem padrão é exibida.

---

## Tecnologias Utilizadas

- **Ruby on Rails**: Framework principal para desenvolvimento da aplicação.
- **GraphQL**: Utilizado para buscar dados da PokéAPI.
- **HTML/ERB**: Para renderização das views.
- **CSS**: Para estilização da interface.

---

## Configuração do Projeto

### Pré-requisitos

- Ruby 3.2 ou superior
- Rails 8.0.2 ou superior
- Bundler instalado (`gem install bundler`)

## Estrutura do Projeto
### Diretórios Principais
- app/controllers: Contém o controlador principal PokedexController, responsável por buscar os dados da API e processá-los.
- app/views: Contém as views, incluindo index.html.erb, que renderiza a lista de Pokémon.
- config/initializers: Configuração do cliente GraphQL para comunicação com a PokéAPI

## Contato
Para dúvidas ou sugestões, entre em contato com o desenvolvedor:

- Nome: Flavio Pirola
- Email: flaviol.pirola@gmail.com
