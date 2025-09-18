import 'package:flutter/material.dart';
import 'package:pokedex_apps/presentation/widgets/loading.dart';

class PokemonRefreshIndicator extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final Widget indicator;

  const PokemonRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    required this.indicator,
  });

  @override
  State<PokemonRefreshIndicator> createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<PokemonRefreshIndicator> {
  bool _isRefreshing = false;

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await widget.onRefresh();
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 60,
      color: Colors.black.withOpacity(0.6),
      backgroundColor: Colors.white.withOpacity(0.4),
      strokeWidth: 1,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: _handleRefresh,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          widget.child,
          if (_isRefreshing)
            Positioned(
              
              top: 23,
              child: PikaLoadingIndicator(),),
        ],
      ),
    );
  }
}
