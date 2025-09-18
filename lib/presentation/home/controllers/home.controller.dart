import 'package:get/get.dart';
import 'package:pokedex_apps/domain/core/utils/pokemon_image_utils.dart';
import 'package:pokedex_apps/domain/core/interfaces/pokemon_repository.dart';
import 'package:pokedex_apps/infrastructure/navigation/routes.dart';
import 'package:pokedex_apps/domain/core/utils/strings.dart';
import 'package:pokedex_apps/domain/core/constants/pokemon_types.dart';

class HomeController extends GetxController {
  final PokemonRepository repository;
  HomeController(this.repository);

  var pokemons = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var selectedType = ''.obs;
  final allTypes = kPokemonTypes;

  var limit = 20;
  final int pageSize = 20;
  bool hasMore = true;
  bool _loadingMoreLock = false;

  @override
  void onInit() {
    super.onInit();
    fetchPokemons();
  }

  Future<void> fetchPokemons() async {
    try {
      isLoading.value = true;
      hasMore = true;
      limit = pageSize;

      final result = await repository.getPokemons(first: limit);

      final finalList =
          result.map((item) {
            final map = Map<String, dynamic>.from(item);
            final number = (map['number'] ?? '').toString();
            final graphqlUrl = (map['image'] ?? '').toString();

            final official = buildOfficialPokedexUrl(number);
            map['resolvedImage'] = official;
            map['graphqlImage'] = graphqlUrl;
            return map;
          }).toList();

      pokemons.assignAll(finalList);

      // using predefined types

      if (result.length < limit) hasMore = false;
    } catch (e, st) {
      print("fetchPokemons error: $e\n$st");
      hasMore = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore) return;
    if (_loadingMoreLock) return;

    _loadingMoreLock = true;
    isMoreLoading.value = true;

    try {
      limit += pageSize;
      final result = await repository.getPokemons(first: limit);

      if (result.length <= pokemons.length) {
        hasMore = false;
        return;
      }

      final newItemsRaw = result.sublist(pokemons.length);
      final newFinalItems =
          newItemsRaw.map((item) {
            final map = Map<String, dynamic>.from(item);
            final number = (map['number'] ?? '').toString();
            final graphqlUrl = (map['image'] ?? '').toString();
            map['resolvedImage'] = buildOfficialPokedexUrl(number);
            map['graphqlImage'] = graphqlUrl;
            return map;
          }).toList();

      pokemons.addAll(newFinalItems);

      // using predefined types

      if (result.length < limit) hasMore = false;
    } catch (e, st) {
      print("loadMore error: $e\n$st");
    } finally {
      isMoreLoading.value = false;
      _loadingMoreLock = false;
    }
  }

  void goToDetail(String name) {
    Get.toNamed(Routes.DETAIL, arguments: {PokeStrings.argName: name});
  }

  List<Map<String, dynamic>> get filteredPokemons {
    final t = selectedType.value.trim();
    if (t.isEmpty) return pokemons;
    return pokemons
        .where((p) {
          final types =
              List<String>.from(
                p['types'] ?? const <String>[],
              ).map((e) => e.toLowerCase()).toList();
          return types.contains(t.toLowerCase());
        })
        .toList(growable: false);
  }

  Future<void> setSelectedType(String? type) async {
    selectedType.value = (type ?? '').trim().toLowerCase();
    await _ensureFilteredMinimum();
  }

  Future<void> _ensureFilteredMinimum() async {
    const int desired = 20; // align with page size
    int safety = 5; // prevent infinite loop
    while (filteredPokemons.length < desired && hasMore && safety > 0) {
      await loadMore();
      safety--;
    }
  }
}
