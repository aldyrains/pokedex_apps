import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex_apps/presentation/widgets/app_bar.dart';
import 'package:pokedex_apps/presentation/widgets/loading.dart';
import 'package:pokedex_apps/presentation/widgets/scaffold.dart';
import 'controllers/home.controller.dart';
import '../widgets/pokemon_card.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PokeballScaffold(
      // appBar: AppBar(
      //   title: const Text("Pokedex"),
      //   centerTitle: false,
      //   elevation: 0,
      // ),
      body: Obx(() {
        if (controller.isLoading.value && controller.pokemons.isEmpty) {
          return const Center(child: PikaLoadingIndicator());
        }

        return Stack(
          children :[
            NestedScrollView(
              headerSliverBuilder: (_, __) => [
        AppMovingTitleSliverAppBar(title: 'Pokedex'),
      ],
              body: NotificationListener<ScrollNotification>(
              onNotification: (scroll) {
                if (scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
                  controller.loadMore();
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: controller.fetchPokemons,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scroll) {
                    if (scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
                      controller.loadMore();
                    }
                    return true;
                  },
                  child: Obx(() {
                    final itemCount =
                        controller.pokemons.length +
                        (controller.isMoreLoading.value ? 1 : 0);
                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: .9,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        if (index < controller.pokemons.length) {
                          final p = controller.pokemons[index];
                          return PokemonCard(
                            name: p['name'] ?? '',
                            number: p['number'] ?? '',
                            image: p['image'] ?? '',
                            types: List<String>.from(p['types'] ?? []),
                            onTap: () {
                              controller.goToDetail(p['name'] ?? '');
                            },
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
            ),
        ]);
      }),
    );
  }
}
