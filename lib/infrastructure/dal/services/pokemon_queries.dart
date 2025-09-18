class PokemonQueries {
  static const String pokemonsQuery = r'''
    query pokemons($first: Int!) {
      pokemons(first: $first) {
        id
        number
        name
        image
        types
      }
    }
  ''';

  static const String pokemonDetailQuery = r'''
    query pokemon($name: String!) {
      pokemon(name: $name) {
        id
        number
        name
        image
        classification
        types
        resistant
        weaknesses
        height {
          minimum
          maximum
        }
        weight {
          minimum
          maximum
        }
        attacks {
          fast {
            name
            type
            damage
          }
          special {
            name
            type
            damage
          }
        }
        evolutions {
          id
          number
          name
          image
        }
      }
    }
  ''';
}
