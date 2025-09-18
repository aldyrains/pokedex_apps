import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex_apps/domain/core/interfaces/pokemon_repository.dart';
import 'package:pokedex_apps/infrastructure/dal/models/pokemon_model.dart';
import 'package:pokedex_apps/infrastructure/theme/colors.dart';
import 'package:pokedex_apps/domain/core/utils/strings.dart';
import 'dart:async';// jika pakai compute

class DetailController extends GetxController {
  final PokemonRepository repository;

  final Rxn<Pokemon> pokemon = Rxn<Pokemon>();

  final isLoading = false.obs;
  final RxList<String> types = <String>[].obs;
  final Rx<Color> bgColor = Colors.white.obs;
  final RxBool isFavorite = false.obs;
  
  DetailController(this.repository);

  @override
  void onReady() {
    super.onReady();
    final args = Get.arguments as Map<String, dynamic>?;

    final passedPokemon = args?['pokemon'] as Pokemon?;
    final name = args?[PokeStrings.argName] as String?;

    if (passedPokemon != null) {
      _applyPokemon(passedPokemon);
    } else if (name != null && name.isNotEmpty) {
      fetchPokemonDetail(name);
    }
  }

  Future<void> fetchPokemonDetail(String name) async {
  try {
    isLoading.value = true;

    final data = await repository.getPokemonDetail(name: name);
    if (data != null) {
      final dataMap = Map<String, dynamic>.from(data); 
      final model = Pokemon.fromMap(dataMap);          
      _applyPokemon(model);                             
    } else {
      Get.snackbar('Info', 'Pokemon tidak ditemukan');
    }
  } catch (e) {
    Get.snackbar('Error', 'Gagal mengambil data: $e');
  } finally {
    isLoading.value = false;
  }
}

  void _applyPokemon(Pokemon p) {
    pokemon.value = p;
    types.assignAll(p.types);
    bgColor.value = backgroundColor(types.isNotEmpty ? types[0] : "");
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }
}

