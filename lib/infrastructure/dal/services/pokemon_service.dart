import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex_apps/domain/core/utils/strings.dart';

abstract class PokemonServiceApi {
  Future<List<Map<String, dynamic>>> getPokemons(int first);
  Future<Map<String, dynamic>?> getPokemonDetail(String name);
}

class PokemonService implements PokemonServiceApi {
  late final GraphQLClient client;

  PokemonService() {
    final HttpLink httpLink = HttpLink(PokeStrings.endpoint);

    client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getPokemons(int first) async {
    const query = r'''
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

    final result = await client.query(
      QueryOptions(
        document: gql(query),
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
    const query = r'''
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

    final result = await client.query(
      QueryOptions(document: gql(query), variables: {"name": name}),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return result.data?['pokemon'] as Map<String, dynamic>?;
  }
}
