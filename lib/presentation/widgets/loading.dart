import 'package:flutter/material.dart';
import 'package:pokedex_apps/domain/core/utils/strings.dart';

class PikaLoadingIndicator extends StatelessWidget {
  const PikaLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
      PokeStrings.pikaLoader,
        fit: BoxFit.contain,
      ),
    );
  }
}