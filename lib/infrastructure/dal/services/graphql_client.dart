import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex_apps/domain/core/utils/strings.dart';

class GraphQLApiClient {
  GraphQLApiClient()
    : client = GraphQLClient(
        link: HttpLink(PokeStrings.endpoint),
        cache: GraphQLCache(store: InMemoryStore()),
      );

  final GraphQLClient client;
}
