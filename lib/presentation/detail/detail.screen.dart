import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex_apps/presentation/detail/section/pokemon_infoCard_about.dart';
import 'package:pokedex_apps/presentation/detail/section/pokemon_infoCard_basestat.dart';
import 'package:pokedex_apps/presentation/detail/section/pokemon_infoCard_evolution.dart';
import 'package:pokedex_apps/presentation/widgets/loading.dart';
import 'package:pokedex_apps/presentation/widgets/scaffold.dart';
import 'package:shimmer/shimmer.dart';
import 'controllers/detail.controller.dart';

class DetailScreen extends GetView<DetailController> {
  final String name;

  const DetailScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.pokemon.isEmpty) {
        return const Center(child: PikaLoadingIndicator());
      }
      return PokeballScaffold(
        backgroundColor: controller.bgColor.value,
        body: Stack(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      Obx(() {
                        final fav = controller.isFavorite.value;
                        return GestureDetector(
                          onTap: controller.toggleFavorite,
                          child: Icon(
                            fav ? Icons.favorite : Icons.favorite_border,
                            color: fav ? Colors.red : Colors.black,
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(
                    controller.pokemonName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "#${controller.number}",
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    children:
                        controller.types
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
                                backgroundColor: controller.bgColor.value
                                    .withOpacity(0.7),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 400,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height - 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, -10),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Obx(() {
                        return TabBar(
                          labelColor: Colors.black,
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              color: controller.bgColor.value,
                              width: 3,
                            ),
                          ),
                          tabs: [
                            Tab(text: "About"),
                            Tab(text: "Base Stats"),
                            Tab(text: "Evolutions"),
                          ],
                        );
                      }),
                      Expanded(
                        child: TabBarView(
                          children: [
                            PokemonInfoCardAbout(), // file yg kamu upload
                            PokemonInfoCardBaseStat(), // file yg kamu upload
                            PokemonInfoCardEvolution(), // file yg kamu upload
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 190,
              left: 0,
              right: 0,
              child: Center(
                child: Hero(
                  tag: controller.heroTag,
                  child: CachedNetworkImage(
                    imageUrl: controller.image,
                    height: context.mediaQuery.size.width * 0.6,
                    fit: BoxFit.contain,
                    placeholder:
                        (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            height: context.mediaQuery.size.width * 0.6,
                            width: context.mediaQuery.size.width * 0.6,
                            color: Colors.white,
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => const Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.grey,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
