import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pokedex_apps/presentation/detail/detail.screen.dart';

import '../../config.dart';
import '../../presentation/screens.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'routes.dart';

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;
  EnvironmentsBadge({required this.child});
  @override
  Widget build(BuildContext context) {
    
    var env = ConfigEnvironments.getEnvironments()['env'];
    return env != Environments.PRODUCTION
        ? Banner(
            location: BannerLocation.topStart,
            message: env!,
            color: env == Environments.QAS ? Colors.blue : Colors.purple,
            child: child,
          )
        : SizedBox(child: child);
  }
}

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.DETAIL,
       page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        final name = args?['name'] ?? '';
        return DetailScreen(name: name);
      },
      binding: DetailControllerBinding(),
    ),
  ];
}
