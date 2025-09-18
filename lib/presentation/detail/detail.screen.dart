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

  const DetailScreen({super.key, required name});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(() {

      if (controller.isLoading.value && controller.pokemon.value == null) {
        return const Scaffold(
          body: Center(child: PikaLoadingIndicator()),
        );
      }

      final p = controller.pokemon.value;

      if (p == null) {
        return const Scaffold(
          body: Center(child: Text('Data tidak tersedia')),
        );
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
                          color: Colors.white,
                        ),
                      ),
                      Obx(() {
                        final fav = controller.isFavorite.value;
                        return GestureDetector(
                          onTap: controller.toggleFavorite,
                          child: Icon(
                            fav ? Icons.favorite : Icons.favorite_border,
                            color: fav ? Colors.red : Colors.white,
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Name
                  Text(
                    p.name,
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  // Number
                  Text(
                    "#${p.number}",
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),

                  // Types chips (controller.types is reactive RxList)
                  Obx(() {
                    return Wrap(
                      spacing: 8,
                      children: controller.types
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
                              backgroundColor:
                                  controller.bgColor.value.withOpacity(0.7),
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
                    );
                  }),
                ],
              ),
            ),

            // Bottom sheet with tabs
            Positioned(
              top: 400,
              left: 0,
              right: 0,
              child: Container(
                height: size.height - 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, -10),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
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
                          labelStyle: const TextStyle(
                            fontFamily: 'Baloo2',
                            fontWeight: FontWeight.w600,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontFamily: 'Baloo2',
                          ),
                          tabs: const [
                            Tab(text: "About"),
                            Tab(text: "Base Stats"),
                            Tab(text: "Evolutions"),
                          ],
                        );
                      }),
                      Expanded(
                        child: TabBarView(
                          children: const [
                            PokemonInfoCardAbout(),
                            PokemonInfoCardBaseStat(),
                            PokemonInfoCardEvolution(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Center image with hero
            Positioned(
              top: 190,
              left: 0,
              right: 0,
              child: Center(
                child: Hero(
                  tag: p.heroTag,
                  child: CachedNetworkImage(
                    imageUrl: p.image ?? '',
                    height: size.width * 0.6,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: size.width * 0.6,
                        width: size.width * 0.6,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
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
