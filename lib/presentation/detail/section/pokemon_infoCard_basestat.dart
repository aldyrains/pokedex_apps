import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_apps/presentation/detail/controllers/detail.controller.dart';

class PokemonInfoCardBaseStat extends StatelessWidget {
  const PokemonInfoCardBaseStat({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailController>();

    Widget bar(String label, num value, double max, Color color) {
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

    Widget attackRow(String name, int dmg, double max, Color color) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: bar(name, dmg, max, color),
      );
    }

    int _parseDamage(dynamic maybe) {
      if (maybe == null) return 0;
      if (maybe is int) return maybe;
      if (maybe is double) return maybe.toInt();
      return int.tryParse(maybe.toString()) ?? 0;
    }

    List<Map<String, dynamic>> _safeList(dynamic v) {
      if (v == null) return const [];
      if (v is List) {
        return v.map((e) {
          if (e is Map) return Map<String, dynamic>.from(e);
          return <String, dynamic>{};
        }).toList();
      }
      return const [];
    }

    return Obx(() {
      final p = controller.pokemon.value;
      final color = controller.bgColor.value;
      if (p == null) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('Data tidak tersedia')),
        );
      }

      // Basic stats (prefer model fields)
      final maxHP = (p.maxHP > 0) ? p.maxHP : 0;
      final maxCP = (p.maxCP > 0) ? p.maxCP : 0;

      // Attacks from model (fallback safe)
      final fast = _safeList(p.fastAttacks);
      final special = _safeList(p.specialAttacks);

      // Compute maxima to scale bars (avoid zero)
      int fastMax = 0;
      for (final a in fast) {
        final dmg = _parseDamage(a['damage']);
        if (dmg > fastMax) fastMax = dmg;
      }
      int specialMax = 0;
      for (final a in special) {
        final dmg = _parseDamage(a['damage']);
        if (dmg > specialMax) specialMax = dmg;
      }

      final fastMaxVal = (fastMax <= 0 ? 100 : fastMax).toDouble();
      final specialMaxVal = (specialMax <= 0 ? 120 : specialMax).toDouble();

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Base Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Fredoka',
              ),
            ),
            const SizedBox(height: 16),
            bar('Max HP', maxHP, 500, color),
            const SizedBox(height: 12),
            bar('Max CP', maxCP, 5000, color),
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
            ...fast.map((a) {
              final name = (a['name'] ?? '').toString();
              final dmg = _parseDamage(a['damage']);
              return Row(
                children: [
                  Expanded(child: attackRow(name, dmg, fastMaxVal, color)),
                  const SizedBox(width: 8),
                  const Text('DMG', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 4),
                  Text(dmg.toString(), style: GoogleFonts.pressStart2p(fontSize: 10)),
                ],
              );
            }).toList(),
            const SizedBox(height: 12),
            Text('Special', style: TextStyle(color: Colors.black.withOpacity(0.6))),
            const SizedBox(height: 8),
            ...special.map((a) {
              final name = (a['name'] ?? '').toString();
              final dmg = _parseDamage(a['damage']);
              return Row(
                children: [
                  Expanded(child: attackRow(name, dmg, specialMaxVal, color)),
                  const SizedBox(width: 8),
                  const Text('DMG', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 4),
                  Text(dmg.toString(), style: GoogleFonts.pressStart2p(fontSize: 10)),
                ],
              );
            }).toList(),
          ],
        ),
      );
    });
  }
}
