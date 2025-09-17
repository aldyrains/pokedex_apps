import 'package:get/get.dart';
import 'package:pokedex_apps/domain/core/utils/pokemon_image_utils.dart';
import 'package:pokedex_apps/infrastructure/dal/services/pokemon_service.dart';


class DetailController extends GetxController {
  final PokemonService service;
  var pokemon = <String, dynamic>{}.obs;
  var isLoading = false.obs;

  DetailController(this.service);

  Future<void> fetchPokemonDetail(String name) async {
    try {
      isLoading.value = true;
      final data = await service.getPokemonDetail(name);
      if (data != null) {
        final map = Map<String, dynamic>.from(data);
        final number = (map['number'] ?? '').toString();
        map['resolvedImage'] = buildOfficialPokedexUrl(number);
        map['graphqlImage'] = (map['image'] ?? '').toString();
        pokemon.value = map;
      }
    } catch (e, st) {
      print("fetchPokemonDetail error: $e\n$st");
    } finally {
      isLoading.value = false;
    }
  }
}
