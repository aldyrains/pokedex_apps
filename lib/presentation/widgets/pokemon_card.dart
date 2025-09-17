import 'package:flutter/material.dart';
import 'package:pokedex_apps/presentation/widgets/loading.dart';
import 'package:pokedex_apps/presentation/widgets/pokemon_image.dart';

class PokemonCard extends StatelessWidget {
  final String name;
  final String number;
  final String image; // graphql image (as backup)
  final String? resolvedImage; // official CDN (build from number) set from controller
  final List<String> types;
  final VoidCallback onTap;

  const PokemonCard({
    Key? key,
    required this.name,
    required this.number,
    required this.image,
    this.resolvedImage,
    required this.types,
    required this.onTap,
  }) : super(key: key);

  Color _backgroundColor(String type) {
    switch (type.toLowerCase()) {
      case "grass":
        return Colors.green.shade300;
      case "fire":
        return Colors.red.shade300;
      case "water":
        return Colors.blue.shade300;
      case "bug":
        return Colors.lightGreen.shade400;
      case "poison":
        return Colors.purple.shade300;
      case "electric":
        return Colors.yellow.shade400;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _backgroundColor(types.isNotEmpty ? types[0] : "");
    final heroTag = 'pokemon-$number';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "#$number",
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),

            Expanded(
              child: PokemonImage(
                resolvedImage: resolvedImage ?? '',
                graphqlImage: image,
                heroTag: heroTag,
                height: 96,
                fit: BoxFit.contain,
                // tintColor: Colors.white.withOpacity(0.1),
                placeholder: const Center(child: PikaLoadingIndicator()),
                errorWidget: const Icon(Icons.broken_image, color: Colors.white70),
              ),
            ),

            Text(
              name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),

            Wrap(
              spacing: 4,
              alignment: WrapAlignment.center,
              children: types
                  .map(
                    (t) => Chip(
                      label: Text(
                        t,
                        style: const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      backgroundColor: Colors.black26,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
