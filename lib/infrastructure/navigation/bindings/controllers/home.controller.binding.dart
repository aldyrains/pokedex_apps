import 'package:get/get.dart';
import 'package:pokedex_apps/infrastructure/dal/services/pokemon_service.dart';

import '../../../../presentation/home/controllers/home.controller.dart';

class HomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find()),
    );
     Get.lazyPut<PokemonService>(() => PokemonService());
  }
}
