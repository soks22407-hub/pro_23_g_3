import 'package:get/get.dart';

import '../core/util/api_client.dart';
import '../service/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<ApiClient>(ApiClient(Get.find<StorageService>()), permanent: true);
  }
}