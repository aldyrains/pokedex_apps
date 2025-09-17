import 'package:flutter/material.dart';
import 'package:pokedex_apps/infrastructure/theme/colors.dart';
import 'package:pokedex_apps/infrastructure/theme/styles.dart';
import 'package:pokedex_apps/infrastructure/theme/themes.dart';
import 'package:pokedex_apps/infrastructure/theme/themes/themes.light.dart';
import 'package:pokedex_apps/infrastructure/theme/typography.dart';


extension AppThemeExtension on BuildContext {
  AppTheme get appTheme {
    final theme = Theme.of(this);
    final appTheme = theme.extension<AppTheme>();
    if (appTheme == null) {
      return const LightAppTheme();
    }
    return appTheme;
  }
  AppThemeTypography get typographies => appTheme.typographies;

  AppThemeColors get colors => appTheme.colors;

  AppThemeStyles get styles => appTheme.styles;
}

extension TextStyleExtension on TextStyle {
  TextStyle withHeight(double? height) => copyWith(height: height);

  TextStyle withColor(Color? color) => copyWith(color: color);

  TextStyle withSize(double? size) => copyWith(fontSize: size);

  // Use [merge] instead of [copyWith] as a workaround for this issue:
  // https://github.com/material-foundation/flutter-packages/issues/141
  TextStyle withWeight(FontWeight? weight) => merge(TextStyle(fontWeight: weight));
}
