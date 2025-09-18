import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pokedex_apps/domain/core/interfaces/pokemon_repository.dart';
import 'package:pokedex_apps/infrastructure/navigation/routes.dart';
import 'package:pokedex_apps/domain/core/utils/strings.dart';
import 'package:pokedex_apps/domain/core/constants/pokemon_types.dart';

List<Map<String, dynamic>> mapPokemonList(List<dynamic> raw) {
  return raw.map<Map<String, dynamic>>((item) {
    final map = Map<String, dynamic>.from(item as Map);
    final number = (map['number'] ?? '').toString().replaceAll(RegExp(r'[^0-9]'), '');
    final padded3 = number.isNotEmpty ? number.padLeft(3, '0') : '';
    map['resolvedImage'] = 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/$padded3.png';
    map['graphqlImage'] = (map['image'] ?? '').toString();
    return map;
  }).toList(growable: false);
}

class HomeController extends GetxController {
  final PokemonRepository repository;
  HomeController(this.repository);

  final pokemons = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isMoreLoading = false.obs;
  final selectedType = ''.obs;

  final allTypes = kPokemonTypes;
  final int pageSize = 20;
  int limit = 20;
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

      final rawResult = await repository
          .getPokemons(first: limit)
          .timeout(const Duration(seconds: 20), onTimeout: () => throw TimeoutException('Request timeout'));

      final finalList = await compute(mapPokemonList, rawResult);
      pokemons.assignAll(finalList);

      hasMore = rawResult.length >= limit;
    } catch (e, st) {
      print("fetchPokemons error: $e\n$st");
      hasMore = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || _loadingMoreLock) return;

    _loadingMoreLock = true;
    isMoreLoading.value = true;

    try {
      final newLimit = (limit + pageSize).clamp(pageSize, 200);
      limit = newLimit;

      final rawResult = await repository
          .getPokemons(first: limit)
          .timeout(const Duration(seconds: 20), onTimeout: () => throw TimeoutException('Request timeout'));

      if (rawResult.length <= pokemons.length) {
        hasMore = false;
        return;
      }

      final newItemsRaw = rawResult.sublist(pokemons.length);
      final newFinalItems = await compute(mapPokemonList, newItemsRaw);
      pokemons.addAll(newFinalItems);

      hasMore = rawResult.length >= limit;
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
    final t = selectedType.value.trim().toLowerCase();
    if (t.isEmpty) return pokemons;

    return pokemons.where((p) {
      final types = List<String>.from(p['types'] ?? const <String>[]).map((e) => e.toLowerCase());
      return types.contains(t);
    }).toList(growable: false);
  }


  Future<void> setSelectedType(String? type) async {
    selectedType.value = (type ?? '').trim().toLowerCase();
    await _ensureFilteredMinimum();
  }

  Future<void> _ensureFilteredMinimum() async {
    const int desired = 20;
    int safety = 5;

    while (filteredPokemons.length < desired && hasMore && safety > 0) {
      await loadMore();
      safety--;
    }
  }
}
