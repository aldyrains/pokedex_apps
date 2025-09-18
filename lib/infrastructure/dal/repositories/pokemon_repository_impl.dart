import 'package:pokedex_apps/domain/core/interfaces/pokemon_repository.dart';
import 'package:pokedex_apps/infrastructure/dal/services/pokemon_service.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonServiceApi service;

  PokemonRepositoryImpl(this.service);

  @override
  Future<List<Map<String, dynamic>>> getPokemons({required int first}) {
    return service.getPokemons(first);
  }

  @override
  Future<Map<String, dynamic>?> getPokemonDetail({required String name}) {
    return service.getPokemonDetail(name);
  }
}
