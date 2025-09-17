import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex_apps/presentation/widgets/loading.dart';
import 'controllers/detail.controller.dart';

class DetailScreen extends GetView<DetailController> {
  final String name;

  const DetailScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    controller.fetchPokemonDetail(name);

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: PikaLoadingIndicator());
        }
        if (controller.pokemon.isEmpty) {
          return const Center(child: Text("No data"));
        }

        final p = controller.pokemon;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.network(p['image'], height: 150),
              const SizedBox(height: 16),
              Text(p['name'], style: Theme.of(context).textTheme.headlineLarge),
              Text("Type: ${(p['types'] as List).join(', ')}"),
              const SizedBox(height: 12),
              Text("Weaknesses: ${(p['weaknesses'] as List).join(', ')}"),
              const SizedBox(height: 12),
              Text("Resistant: ${(p['resistant'] as List).join(', ')}"),
            ],
          ),
        );
      }),
    );
  }
}
