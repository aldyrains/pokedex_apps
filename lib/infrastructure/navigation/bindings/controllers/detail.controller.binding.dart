import 'package:get/get.dart';
import 'package:pokedex_apps/infrastructure/dal/services/pokemon_service.dart';
import 'package:pokedex_apps/presentation/detail/controllers/detail.controller.dart';

class DetailControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailController>(
      () => DetailController(Get.find()),
    );
     Get.lazyPut<PokemonService>(() => PokemonService());
  }
}
