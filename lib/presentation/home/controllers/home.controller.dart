import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pokedex_apps/domain/core/interfaces/pokemon_repository.dart';
import 'package:pokedex_apps/infrastructure/navigation/routes.dart';
import 'package:pokedex_apps/domain/core/utils/strings.dart';
import 'package:pokedex_apps/domain/core/constants/pokemon_types.dart';


List<Map<String, dynamic>> _mapPokemonList(List<dynamic> raw) {
  return raw.map<Map<String, dynamic>>((item) {
    final map = Map<String, dynamic>.from(item as Map);
    final number = (map['number'] ?? '').toString();
    final graphqlUrl = (map['image'] ?? '').toString();
    final padded = number.replaceAll(RegExp(r'[^0-9]'), '');
    final padded3 = (int.tryParse(padded) != null) ? int.parse(padded).toString().padLeft(3, '0') : number;
    final official = 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/$padded3.png';
    map['resolvedImage'] = official;
    map['graphqlImage'] = graphqlUrl;
    return map;
  }).toList(growable: false);
}
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

    final rawResult = await repository.getPokemons(first: limit).timeout(
      const Duration(seconds: 20),
      onTimeout: () {
        throw TimeoutException("Request timeout");
      },
    );

    final finalList = await compute(_mapPokemonList, rawResult);

    pokemons.assignAll(finalList);

    if (rawResult.length < limit) hasMore = false;
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
    final int newLimit = (limit + pageSize).clamp(pageSize, 200);
    limit = newLimit;

    final rawResult = await repository.getPokemons(first: limit).timeout(
      const Duration(seconds: 20),
      onTimeout: () {
        throw TimeoutException("Request timeout");
      },
    );

    if (rawResult.length <= pokemons.length) {
      hasMore = false;
      return;
    }

    final newItemsRaw = rawResult.sublist(pokemons.length);
    final newFinalItems = await compute(_mapPokemonList, newItemsRaw);

    pokemons.addAll(newFinalItems);

    if (rawResult.length < limit) hasMore = false;
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
    const int desired = 20; 
    int safety = 5; 
    while (filteredPokemons.length < desired && hasMore && safety > 0) {
      await loadMore();
      safety--;
    }
  }
}
