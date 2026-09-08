import 'package:pro_23_g_3/controller/login_controller.dart';
import 'package:pro_23_g_3/repository/login_repository.dart';
import 'package:get/get.dart';

import '../controller/register_controller.dart';
import '../core/util/api_client.dart';
import '../service/storage_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginRepository>(
      () => LoginRepository(Get.find<ApiClient>(), Get.find<StorageService>()),
    );
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<LoginRepository>()),
    );
    Get.lazyPut<RegisterController>(() => RegisterController(Get.find<LoginRepository>()));
  }
}
