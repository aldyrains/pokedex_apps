import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex_apps/domain/core/utils/pokemon_image_utils.dart';
import 'package:pokedex_apps/domain/core/interfaces/pokemon_repository.dart';
import 'package:pokedex_apps/infrastructure/theme/colors.dart';
import 'package:pokedex_apps/domain/core/utils/strings.dart';

class DetailController extends GetxController {
  final PokemonRepository repository;
  var pokemon = <String, dynamic>{}.obs;
  var isLoading = false.obs;
  var types = <String>[];
  Rx<Color> bgColor = Colors.white.obs;
  RxBool isFavorite = false.obs;
  DetailController(this.repository);

  @override
  void onReady() {
    super.onReady();
    final args = Get.arguments as Map<String, dynamic>?;
    final name = args?[PokeStrings.argName] as String?;
    if (name != null && name.isNotEmpty) {
      fetchPokemonDetail(name);
    }
  }

  Future<void> fetchPokemonDetail(String name) async {
    try {
      isLoading.value = true;
      final data = await repository.getPokemonDetail(name: name);
      if (data != null) {
        final map = Map<String, dynamic>.from(data);
        final number = (map['number'] ?? '').toString();
        map['resolvedImage'] = buildOfficialPokedexUrl(number);
        map['graphqlImage'] = (map['image'] ?? '').toString();
        pokemon.value = map;
        types = (map['types'] as List).map((t) => t.toString()).toList();
        bgColor.value = backgroundColor(types.isNotEmpty ? types[0] : "");
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> get p => pokemon;

  String get number => p["number"].toString().padLeft(3, "0");
  String get heroTag => 'pokemon-$number';
  String get pokemonName => p["name"] ?? '';
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
  int get maxHP =>
      (p["maxHP"] ?? 0) is int
          ? p["maxHP"] as int
          : int.tryParse((p["maxHP"] ?? '0').toString()) ?? 0;
  int get maxCP =>
      (p["maxCP"] ?? 0) is int
          ? p["maxCP"] as int
          : int.tryParse((p["maxCP"] ?? '0').toString()) ?? 0;
  List<Map<String, dynamic>> get evolutions =>
      (p["evolutions"] as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
  List<Map<String, dynamic>> get fastAttacks =>
      (p["attacks"]?['fast'] as List? ?? const [])
          .map((a) => Map<String, dynamic>.from(a as Map))
          .toList();
  List<Map<String, dynamic>> get specialAttacks =>
      (p["attacks"]?['special'] as List? ?? const [])
          .map((a) => Map<String, dynamic>.from(a as Map))
          .toList();

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }
}
