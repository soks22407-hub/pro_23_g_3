import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../router/app_route.dart';
import '../service/storage_service.dart';

class SplashController extends GetxController {
  SplashController(this._storage);

  final StorageService _storage;

  final loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    loading.value = true;

    await Future.delayed(const Duration(seconds: 3));

    final String? token = await _storage.getString('token');

    loading.value = false;

    if (token != null && token.isNotEmpty) {
      Get.offAllNamed(AppRoute.main);
    } else {
      Get.offAllNamed(AppRoute.login);
    }
  }
}