import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex_apps/domain/core/utils/strings.dart';
import 'package:pokedex_apps/infrastructure/theme/extensions.dart';
import 'package:pokedex_apps/infrastructure/theme/colors.dart';
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
    return Obx(() {
      final sel = controller.selectedType.value;
      final bg = sel.isEmpty ? context.colors.background : backgroundColor(sel);

      return PokeballScaffold(
        backgroundColor: bg.withOpacity(0.9),
        floatingActionButton: _buildFilterButton(bg, sel),
        body: _buildBody(),
      );
    });
  }

  Widget _buildFilterButton(Color bg, String sel) {
    return FloatingActionButton.extended(
      onPressed: () => _showFilterBottomSheet(Get.context!),
      icon: Icon(Icons.filter_list, size: 20, color: sel.isEmpty ? Colors.black : Colors.white),
      label: Text(
        'Filter',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: sel.isEmpty ? Colors.black : Colors.white,
        ),
      ),
      backgroundColor: bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      elevation: 3,
    );
  }

  Widget _buildBody() {
    if (controller.isLoading.value && controller.pokemons.isEmpty) {
      return const Center(child: PikaLoadingIndicator());
    }

    return NestedScrollView(
      headerSliverBuilder: (_, __) => [AppMovingTitleSliverAppBar(title: PokeStrings.homeTitle)],
      body: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll.metrics.pixels >= scroll.metrics.maxScrollExtent) {
            controller.loadMore();
          }
          return true;
        },
        child: PokemonRefreshIndicator(
          onRefresh: controller.fetchPokemons,
          indicator: const PikaLoadingIndicator(),
          child: Obx(() => _buildPokemonGrid()),
        ),
      ),
    );
  }

  Widget _buildPokemonGrid() {
    final filtered = controller.filteredPokemons;
    final isLoadingMore = controller.isMoreLoading.value;
    final itemCount = filtered.length + (isLoadingMore ? 1 : 0);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildSelectedTypeChip()),
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index < filtered.length) {
                final p = filtered[index];
                return _buildPokemonGridItem(p);
              } else {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: PikaLoadingIndicator(),
                  ),
                );
              }
            }, childCount: itemCount),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedTypeChip() {
    return Obx(() {
      final sel = controller.selectedType.value;
      if (sel.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: InputChip(
            label: Text('Type: $sel'),
            onDeleted: () => controller.setSelectedType(''),
          ),
        ),
      );
    });
  }

  Widget _buildPokemonGridItem(Map<String, dynamic> p) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), spreadRadius: 1, blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: PokemonCard(
        name: p['name'] ?? '',
        number: p['number'] ?? '',
        image: p['resolvedImage'] ?? p['graphqlImage'] ?? '',
        types: List<String>.from(p['types'] ?? []),
        onTap: () => controller.goToDetail(p['name'] ?? ''),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => Obx(() => _buildFilterList(ctx, scrollController)),
      ),
    );
  }

  Widget _buildFilterList(BuildContext ctx, ScrollController scrollController) {
    final selected = controller.selectedType.value;

    return ListView(
      controller: scrollController,
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Filter by Type',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        RadioListTile<String>(
          value: '',
          groupValue: selected,
          title: const Text('All Types'),
          secondary: _TypeDot(color: Colors.grey.shade300),
          onChanged: (v) {
            controller.setSelectedType(v);
            Navigator.of(ctx).pop();
          },
        ),
        ...controller.allTypes.map(
          (t) => RadioListTile<String>(
            value: t,
            groupValue: selected,
            title: Text(t),
            secondary: _TypeDot(color: backgroundColor(t)),
            onChanged: (v) {
              controller.setSelectedType(v);
              Navigator.of(ctx).pop();
            },
          ),
        ),
      ],
    );
  }
}

class _TypeDot extends StatelessWidget {
  final Color color;
  const _TypeDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12),
      ),
    );
  }
}
