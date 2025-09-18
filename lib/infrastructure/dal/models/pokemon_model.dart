// lib/models/pokemon.dart
import 'package:pokedex_apps/domain/core/utils/pokemon_image_utils.dart';

class Pokemon {
  final Map<String, dynamic> raw; 
  final int numberInt;
  final String name;
  final List<String> types;
  final String? resolvedImage; // bisa null
  final String? graphqlImage;
  final String category;
  final String description;
  final List<String> abilities;
  final List<Map<String, dynamic>> stats;
  final int maxHP;
  final int maxCP;
  final List<Map<String, dynamic>> evolutions;
  final List<Map<String, dynamic>> fastAttacks;
  final List<Map<String, dynamic>> specialAttacks;
  final String height;
  final String weight;

  Pokemon({
    required this.raw,
    required this.numberInt,
    required this.name,
    required this.types,
    this.resolvedImage,
    this.graphqlImage,
    required this.category,
    required this.description,
    required this.abilities,
    required this.stats,
    required this.maxHP,
    required this.maxCP,
    required this.evolutions,
    required this.fastAttacks,
    required this.specialAttacks,
    required this.height,
    required this.weight,
  });

  factory Pokemon.fromMap(Map<String, dynamic> p) {
    final number = (p['number'] ?? '0').toString().padLeft(3, '0');
    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    List<String> safeStringList(dynamic v) {
      if (v is List) return v.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
      return const <String>[];
    }

    List<Map<String, dynamic>> safeMapList(dynamic v) {
      if (v is List) return v.map((e) => Map<String, dynamic>.from(e as Map? ?? {})).toList();
      return const <Map<String, dynamic>>[];
    }

    List<Map<String, dynamic>> evols = safeMapList(p['evolutions']);
    evols = evols.map((map) {
      final m = Map<String, dynamic>.from(map);
      final img = (m['image'] ?? '').toString().trim();
      if (img.isEmpty) {
        final num = (m['number'] ?? '').toString();
        m['image'] = buildOfficialPokedexUrl(num);
      }
      return m;
    }).toList();

    return Pokemon(
      
      raw: Map<String, dynamic>.from(p),
      numberInt: parseInt(p['number']),
      name: p['name']?.toString() ?? '',
      types: safeStringList(p['types']),
      resolvedImage: (p['resolvedImage'] ?? buildOfficialPokedexUrl(number)).toString(),
      graphqlImage: (p['graphqlImage'] ?? p['image'] ?? '').toString().trim().isEmpty ? null : (p['graphqlImage']?.toString() ?? p['image']?.toString()),
      category: p['category']?.toString() ?? '',
      description: p['description']?.toString() ?? '',
      abilities: safeStringList(p['abilities']),
      stats: safeMapList(p['stats']),
      maxHP: parseInt(p['maxHP']),
      maxCP: parseInt(p['maxCP']),
      evolutions: evols,
      fastAttacks: safeMapList(p['attacks']?['fast']),
      specialAttacks: safeMapList(p['attacks']?['special']),
      height: "${p['height']?['minimum'] ?? "-"} - ${p['height']?['maximum'] ?? "-"}",
      weight: "${p['weight']?['minimum'] ?? "-"} - ${p['weight']?['maximum'] ?? "-"}",
    );
  }
    String? get image => resolvedImage;

  String get number => numberInt.toString().padLeft(3, '0');
  String get heroTag => 'pokemon-$number';
}

