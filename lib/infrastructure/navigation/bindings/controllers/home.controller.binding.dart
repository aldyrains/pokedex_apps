import 'package:get/get.dart';
import 'package:pokedex_apps/infrastructure/dal/services/pokemon_service.dart';
import 'package:pokedex_apps/infrastructure/dal/services/graphql_client.dart';
import 'package:pokedex_apps/domain/core/interfaces/pokemon_repository.dart';
import 'package:pokedex_apps/infrastructure/dal/repositories/pokemon_repository_impl.dart';

import '../../../../presentation/home/controllers/home.controller.dart';

class HomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GraphQLApiClient>(() => GraphQLApiClient());
    Get.lazyPut<PokemonServiceApi>(
      () => PokemonService(Get.find<GraphQLApiClient>().client),
    );
    Get.lazyPut<PokemonRepository>(() => PokemonRepositoryImpl(Get.find()));
    Get.lazyPut<HomeController>(() => HomeController(Get.find()));
  }
}
