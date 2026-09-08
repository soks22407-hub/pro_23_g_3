import 'package:get/get.dart';

import '../controller/splash_controller.dart';
import '../service/storage_service.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController(Get.find<StorageService>()));
  }
}