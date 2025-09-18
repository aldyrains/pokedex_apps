import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex_apps/infrastructure/dal/services/pokemon_queries.dart';

abstract class PokemonServiceApi {
  Future<List<Map<String, dynamic>>> getPokemons(int first);
  Future<Map<String, dynamic>?> getPokemonDetail(String name);
}

class PokemonService implements PokemonServiceApi {
  final GraphQLClient client;
  PokemonService(this.client);

  @override
  Future<List<Map<String, dynamic>>> getPokemons(int first) async {
    final result = await client.query(
      QueryOptions(
        document: gql(PokemonQueries.pokemonsQuery),
        variables: {"first": first},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return (result.data?['pokemons'] as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  @override
  Future<Map<String, dynamic>?> getPokemonDetail(String name) async {
    final result = await client.query(
      QueryOptions(
        document: gql(PokemonQueries.pokemonDetailQuery),
        variables: {"name": name},
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return result.data?['pokemon'] as Map<String, dynamic>?;
  }
}
