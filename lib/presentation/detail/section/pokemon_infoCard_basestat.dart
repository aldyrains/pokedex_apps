import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_apps/presentation/detail/controllers/detail.controller.dart';

class PokemonInfoCardBaseStat extends StatelessWidget {
  const PokemonInfoCardBaseStat({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailController>();
    final color = controller.bgColor.value;

    Widget bar(String label, num value, double max) {
      final v = value.toDouble().clamp(0, max);
      final ratio = (v / max).clamp(0.0, 1.0);
      return Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text(
              value.toString(),
              style: GoogleFonts.pressStart2p(fontSize: 10),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        ],
      );
    }

    Widget attackRow(String name, int dmg, double max) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: bar(name, dmg, max),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Base Stats',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Fredoka',
            ),
          ),
          const SizedBox(height: 16),
          bar('Max HP', controller.maxHP, 500),
          const SizedBox(height: 12),
          bar('Max CP', controller.maxCP, 5000),
          const SizedBox(height: 24),
          const Text(
            'Attacks',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Fredoka',
            ),
          ),
          const SizedBox(height: 8),
          Text('Fast', style: TextStyle(color: Colors.black.withOpacity(0.6))),
          const SizedBox(height: 8),
          ...(() {
            final fast = controller.fastAttacks;
            int fastMax = 0;
            for (final a in fast) {
              final dmg = int.tryParse((a['damage'] ?? '0').toString()) ?? 0;
              if (dmg > fastMax) fastMax = dmg;
            }
            final maxVal = (fastMax <= 0 ? 100 : fastMax).toDouble();
            return fast.map((a) {
              final name = (a['name'] ?? '').toString();
              final dmg = int.tryParse((a['damage'] ?? '0').toString()) ?? 0;
              return Row(
                children: [
                  Expanded(child: attackRow(name, dmg, maxVal)),
                  const SizedBox(width: 8),
                  Text(
                    'DMG',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dmg.toString(),
                    style: GoogleFonts.pressStart2p(fontSize: 10),
                  ),
                ],
              );
            }).toList();
          })(),
          const SizedBox(height: 12),
          Text(
            'Special',
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
          const SizedBox(height: 8),
          ...(() {
            final special = controller.specialAttacks;
            int specialMax = 0;
            for (final a in special) {
              final dmg = int.tryParse((a['damage'] ?? '0').toString()) ?? 0;
              if (dmg > specialMax) specialMax = dmg;
            }
            final maxVal = (specialMax <= 0 ? 120 : specialMax).toDouble();
            return special.map((a) {
              final name = (a['name'] ?? '').toString();
              final dmg = int.tryParse((a['damage'] ?? '0').toString()) ?? 0;
              return Row(
                children: [
                  Expanded(child: attackRow(name, dmg, maxVal)),
                  const SizedBox(width: 8),
                  Text(
                    'DMG',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dmg.toString(),
                    style: GoogleFonts.pressStart2p(fontSize: 10),
                  ),
                ],
              );
            }).toList();
          })(),
        ],
      ),
    );
  }
}
