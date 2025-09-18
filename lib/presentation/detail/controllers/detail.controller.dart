import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex_apps/domain/core/utils/pokemon_image_utils.dart';
import 'package:pokedex_apps/infrastructure/dal/services/pokemon_service.dart';
import 'package:pokedex_apps/infrastructure/theme/colors.dart';

class DetailController extends GetxController {
  final PokemonService service;
  var pokemon = <String, dynamic>{}.obs;
  var isLoading = false.obs;
  var types = <String>[];
  Rx<Color> bgColor = Colors.white.obs;
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
        types = (map['types'] as List).map((t) => t.toString()).toList();
        bgColor.value = backgroundColor(types.isNotEmpty ? types[0] : "");
      }
    } catch (e, st) {
      print("fetchPokemonDetail error: $e\n$st");
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> get p => pokemon;

  String get number => p["number"].toString().padLeft(3, "0");
  String get heroTag => 'pokemon-$number';
  String get pokemonName => p["name"];
  List<String> get pokemonTypes =>
      (p["types"] as List).map((t) => t.toString()).toList();
  String get image => p["resolvedImage"] ?? p["graphqlImage"] ?? "";
  String get height =>
      "${p["height"]?["minimum"] ?? "-"} - ${p["height"]?["maximum"] ?? "-"}";
  String get weight =>
      "${p["weight"]?["minimum"] ?? "-"} - ${p["weight"]?["maximum"] ?? "-"}";
  String get category => p["category"] ?? "";
  String get description => p["description"] ?? "";
  List<String> get abilities =>
      (p["abilities"] as List).map((a) => a.toString()).toList();
  List<Map<String, dynamic>> get stats =>
      (p["stats"] as List).map((s) => Map<String, dynamic>.from(s)).toList();
  List<Map<String, dynamic>> get evolutions =>
      (p["evolutions"] as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
}
