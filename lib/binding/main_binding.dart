import 'package:pro_23_g_3/binding/post_binding.dart';
import 'package:get/get.dart';

import '../controller/post_controller.dart';
import '../controller/user_controller.dart';
import '../core/util/api_client.dart';
import '../repository/post_repository.dart';
import '../repository/user_repository.dart';


/// Dependencies for the tabbed shell.
///
/// The tabs are built inside `MainScreen`, not reached through their own
/// routes, so whatever they need has to be registered here.
class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostRepository>(() => PostRepository(Get.find<ApiClient>()));
    Get.lazyPut<PostController>(() => PostController(Get.find<PostRepository>()));

    Get.lazyPut<UserRepository>(() => UserRepository(Get.find<ApiClient>()));
    Get.lazyPut<UserController>(() => UserController(Get.find<UserRepository>()));
  }
}