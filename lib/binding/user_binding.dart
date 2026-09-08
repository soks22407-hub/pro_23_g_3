import 'package:pro_23_g_3/controller/user_controller.dart';
import 'package:pro_23_g_3/repository/user_repository.dart';
import 'package:get/get.dart';

import '../controller/post_controller.dart';
import '../core/util/api_client.dart';
import '../repository/post_repository.dart';
import '../service/storage_service.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorageService>(() => StorageService());

    Get.lazyPut<ApiClient>(() => ApiClient(Get.find<StorageService>()));

    Get.lazyPut<UserRepository>(() => UserRepository(Get.find<ApiClient>()));

    Get.lazyPut<UserController>(
          () => UserController(Get.find<UserRepository>()),
    );
  }
}
