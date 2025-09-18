import 'package:flutter/material.dart';
import 'package:pokedex_apps/infrastructure/theme/colors.dart';

import 'package:pokedex_apps/infrastructure/theme/typography.dart';


class AppTheme extends ThemeExtension<AppTheme> {
  final String name;
  final String fontFamily;
  final Brightness brightness;
  final AppThemeColors colors;
  final AppThemeTypography typographies;

  const AppTheme({
    required this.name,
    required this.brightness,
    required this.colors,
    this.typographies = const AppThemeTypography(),
    this.fontFamily = 'Poppins',
  });

  ColorScheme get baseColorScheme => brightness == Brightness.light //
      ? const ColorScheme.light()
      : const ColorScheme.dark();

 
  @override
  AppTheme copyWith({
    String? name,
    Brightness? brightness,
    AppThemeColors? colors,
    AppThemeTypography? typographies,

  }) {
    return AppTheme(
      brightness: brightness ?? this.brightness,
      name: name ?? this.name,
      colors: colors ?? this.colors,
      typographies: typographies ?? this.typographies,
    );
  }

  @override
  AppTheme lerp(covariant ThemeExtension<AppTheme>? other, double t) {
    if (other is! AppTheme) {
      return this;
    }
    return AppTheme(
      name: name,
      brightness: brightness,
      colors: colors.lerp(other.colors, t),
      typographies: typographies.lerp(other.typographies, t),

    );
  }
}
