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
                style: const TextStyle(color: Colors.black, fontSize: 18),
                children: [
                  TextSpan(
                    text: "$title : ",
                    style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 18),
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

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailController>();
    final p = controller.p;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(Icons.pets, "Classification", p["classification"] ?? "-"),
          _buildRow(Icons.bolt, "Types", (p["types"] as List?)?.join(", ") ?? "-"),
          _buildRow(Icons.shield, "Resistant", (p["resistant"] as List?)?.join(", ") ?? "-"),
          _buildRow(Icons.warning, "Weaknesses", (p["weaknesses"] as List?)?.join(", ") ?? "-"),
    
          const SizedBox(height: 12),
          _buildRow(Icons.favorite, "Max HP", "${p["maxHP"] ?? "-"}"),
          _buildRow(Icons.battery_full, "Max CP", "${p["maxCP"] ?? "-"}"),
    
          const SizedBox(height: 12),
          _buildRow(
            Icons.height,
            "Height",
            "${p["height"]?["minimum"] ?? "-"} - ${p["height"]?["maximum"] ?? "-"}",
          ),
          _buildRow(
            Icons.monitor_weight,
            "Weight",
            "${p["weight"]?["minimum"] ?? "-"} - ${p["weight"]?["maximum"] ?? "-"}",
          ),
        ],
      ),
    );
  }
}
