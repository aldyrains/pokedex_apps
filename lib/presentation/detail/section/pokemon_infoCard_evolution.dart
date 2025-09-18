import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex_apps/presentation/detail/controllers/detail.controller.dart';

class PokemonInfoCardEvolution extends StatelessWidget {
  const PokemonInfoCardEvolution({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailController>();

    // Misalnya kita ambil evolusi pertama (index 0)
    final evolutions = controller.evolutions;
    final hasEvolution = evolutions.isNotEmpty;
    final firstEvolution = hasEvolution ? evolutions.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Text(
            "Evolution Chain",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(controller.image),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.pokemonName,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(width: 16),

            if (hasEvolution) ...[
              Column(
                children: [
                  const Icon(Icons.arrow_forward, color: Colors.grey),
                  const SizedBox(height: 4),
                  Text(
                    "(Level ${firstEvolution?["min_level"] ?? "16"})",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage:
                        NetworkImage(firstEvolution?["image"] ?? ""),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    firstEvolution?["name"] ?? "-",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }
}
