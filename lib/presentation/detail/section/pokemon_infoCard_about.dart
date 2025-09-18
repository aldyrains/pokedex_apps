import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex_apps/presentation/detail/controllers/detail.controller.dart';

class PokemonInfoCardAbout extends StatelessWidget {
  const PokemonInfoCardAbout({super.key});

  Widget _buildRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16),
                children: [
                  TextSpan(
                    text: "$title : ",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _joinList(dynamic maybeList) {
    if (maybeList == null) return '-';
    if (maybeList is List) {
      final list = maybeList.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
      return list.isEmpty ? '-' : list.join(', ');
    }
    return maybeList.toString();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailController>();

    return Obx(() {
      final p = controller.pokemon.value;
      if (p == null) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('Data tidak tersedia')),
        );
      }

      final classification =
          (p.category.isNotEmpty == true ? p.category : (p.raw['classification']?.toString())) ??
              '-';

      final types = p.types.isNotEmpty ? p.types.join(', ') : _joinList(p.raw['types']);
      final resistant = _joinList(p.raw['resistant']);
      final weaknesses = _joinList(p.raw['weaknesses']);

      final maxHP = (p.maxHP > 0) ? p.maxHP.toString() : (p.raw['maxHP']?.toString() ?? '-');
      final maxCP = (p.maxCP > 0) ? p.maxCP.toString() : (p.raw['maxCP']?.toString() ?? '-');
      final height = (p.height.isNotEmpty == true) ? p.height : (p.raw['height'] != null
          ? "${p.raw['height']?['minimum'] ?? '-'} - ${p.raw['height']?['maximum'] ?? '-'}"
          : '-');

      final weight = (p.weight.isNotEmpty == true) ? p.weight : (p.raw['weight'] != null
          ? "${p.raw['weight']?['minimum'] ?? '-'} - ${p.raw['weight']?['maximum'] ?? '-'}"
          : '-');

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow(Icons.pets, "Classification", classification),
            _buildRow(Icons.bolt, "Types", types),
            _buildRow(Icons.shield, "Resistant", resistant),
            _buildRow(Icons.warning, "Weaknesses", weaknesses),

            const SizedBox(height: 12),
            _buildRow(Icons.favorite, "Max HP", maxHP),
            _buildRow(Icons.battery_full, "Max CP", maxCP),

            const SizedBox(height: 12),
            _buildRow(Icons.height, "Height", height),
            _buildRow(Icons.monitor_weight, "Weight", weight),
          ],
        ),
      );
    });
  }
}
