import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/util/api_exception.dart';
import '../repository/login_repository.dart';
import '../router/app_route.dart';

class RegisterController extends GetxController {
  RegisterController(this._loginRepo);

  final LoginRepository _loginRepo;

  final usernameController = TextEditingController();
  final nickNameController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final obscurePassword = true.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> register() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      await _loginRepo.register(
        username: usernameController.text.trim(),
        nickName: nickNameController.text.trim().isEmpty
            ? null
            : nickNameController.text.trim(),
        password: passwordController.text,
      );

      Get.offAllNamed(AppRoute.main);
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    nickNameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}