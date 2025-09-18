import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex_apps/presentation/detail/controllers/detail.controller.dart';
import 'package:pokedex_apps/domain/core/utils/strings.dart';

class PokemonInfoCardEvolution extends StatelessWidget {
  const PokemonInfoCardEvolution({super.key});

  Widget _node({
    required String imageUrl,
    required String name,
    String? subtitle,
    required VoidCallback? onTap,
    double radius = 56,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: radius * 2,
              height: radius * 2,
              fit: BoxFit.cover,
              placeholder: (ctx, url) => Container(
                width: radius * 2,
                height: radius * 2,
                color: Colors.grey.shade200,
                child: const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
              ),
              errorWidget: (ctx, url, err) => Container(
                width: radius * 2,
                height: radius * 2,
                color: Colors.grey.shade200,
                child: const Icon(Icons.broken_image, size: 32, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: radius * 2 + 10,
            child: Text(
              name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
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

      final baseImage = p.image!.isNotEmpty ? p.image : (p.raw['image']?.toString() ?? '');
      final baseName = p.name.isNotEmpty ? p.name : (p.raw['name']?.toString() ?? '-');

      final evols = List<Map<String, dynamic>>.from(p.evolutions);
      if (evols.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Evolution Chain', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Center(child: Text('No evolutions available', style: TextStyle(color: Colors.grey.shade600))),
            ],
          ),
        );
      }

      final nodes = <Widget>[];
      nodes.add(_node(
        imageUrl: baseImage ?? '',
        name: baseName,
        subtitle: '#${p.number}',
        onTap: null, 
      ));

      for (final e in evols) {
        final level = (e['min_level'] ?? e['level'] ?? e['evolutionLevel'] ?? e['minLevel'])?.toString();
        final evoImage = (e['image'] ?? '').toString();
        final evoName = (e['name'] ?? e['species'] ?? e['title'])?.toString() ?? '-';

        nodes.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              const Icon(Icons.arrow_forward, color: Colors.grey),
              const SizedBox(height: 4),
              Text(
                level != null ? 'Lvl $level' : '',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ));

        nodes.add(_node(
          imageUrl: evoImage,
          name: evoName,
          subtitle: null,
          onTap: () {
            final targetName = evoName;
            if (targetName.isNotEmpty) {
              Get.toNamed('/detail', arguments: {PokeStrings.argName: targetName});
            }
          },
        ));
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
              child: Text('Evolution Chain', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: nodes,
              ),
            ),
          ],
        ),
      );
    });
  }
}
