import 'package:get/get.dart';

import '../controller/post_controller.dart';
import '../core/util/api_client.dart';
import '../repository/post_repository.dart';
import '../service/storage_service.dart';

class PostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorageService>(() => StorageService());

    Get.lazyPut<ApiClient>(() => ApiClient(Get.find<StorageService>()));

    Get.lazyPut<PostRepository>(() => PostRepository(Get.find<ApiClient>()));

    Get.lazyPut<PostController>(
      () => PostController(Get.find<PostRepository>()),
    );
  }
}
