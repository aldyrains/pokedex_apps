import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex_apps/domain/core/utils/strings.dart';
import 'package:pokedex_apps/infrastructure/theme/extensions.dart';
import 'package:pokedex_apps/presentation/widgets/app_bar.dart';
import 'package:pokedex_apps/presentation/widgets/loading.dart';
import 'package:pokedex_apps/presentation/widgets/pokemon_refresh_control.dart';
import 'package:pokedex_apps/presentation/widgets/scaffold.dart';
import 'controllers/home.controller.dart';
import '../widgets/pokemon_card.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PokeballScaffold(
      backgroundColor: context.colors.background,
      body: Obx(() {
        if (controller.isLoading.value && controller.pokemons.isEmpty) {
          return const Center(child: PikaLoadingIndicator());
        }

        return Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder:
                  (_, __) => [
                    AppMovingTitleSliverAppBar(title: PokeStrings.homeTitle),
                  ],
              body: NotificationListener<ScrollNotification>(
                onNotification: (scroll) {
                  if (scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
                    controller.loadMore();
                  }
                  return true;
                },
                child: PokemonRefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchPokemons();
                  },
                  indicator: const PikaLoadingIndicator(),
                  child: Obx(() {
                    final itemCount =
                        controller.pokemons.length +
                        (controller.isMoreLoading.value ? 1 : 0);
                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: .9,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        if (index < controller.pokemons.length) {
                          final p = controller.pokemons[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: PokemonCard(
                              name: p['name'] ?? '',
                              number: p['number'] ?? '',
                              image:
                                  p["resolvedImage"] ?? p["graphqlImage"] ?? "",
                              types: List<String>.from(p['types'] ?? []),
                              onTap: () {
                                controller.goToDetail(p['name'] ?? '');
                              },
                            ),
                          );
                        } else {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: PikaLoadingIndicator(),
                            ),
                          );
                        }
                      },
                    );
                  }),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
