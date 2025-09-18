import 'package:flutter/material.dart';
import 'package:pokedex_apps/infrastructure/theme/colors.dart';
import 'package:pokedex_apps/presentation/widgets/loading.dart';
import 'package:pokedex_apps/presentation/widgets/pokemon_image.dart';

class PokemonCard extends StatelessWidget {
  final String name;
  final String number;
  final String image; 
  final String?
  resolvedImage; 
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

 

  @override
  Widget build(BuildContext context) {
    final Color bg = backgroundColor(types.isNotEmpty ? types[0] : "");
    final heroTag = 'pokemon-$number';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 8.0,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Column(
                              spacing: 4,
                              children:
                                  types
                                      .map(
                                        (t) => Chip(
                                          label: Text(
                                            t,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          backgroundColor: bg.withOpacity(0.7),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                              visualDensity: VisualDensity.compact,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "#$number",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),

            Positioned(
              bottom: 0,
              right: 0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PokemonImage(
                    resolvedImage: resolvedImage ?? '',
                    graphqlImage: image,
                    heroTag: heroTag,
                    width: 130,
                    height: 130,
                    fit: BoxFit.contain,
                    placeholder: const Center(child: PikaLoadingIndicator()),
                    errorWidget: const Icon(
                      Icons.broken_image,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
