abstract class PokemonRepository {
  Future<List<Map<String, dynamic>>> getPokemons({required int first});
  Future<Map<String, dynamic>?> getPokemonDetail({required String name});
}
