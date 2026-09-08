import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_23_g_3/model/login_model.dart';
import 'package:pro_23_g_3/repository/login_repository.dart';

import '../router/app_route.dart';

class LoginController extends GetxController {
  LoginController(this._loginRepo);

  final LoginRepository _loginRepo;

  final usernameController = TextEditingController(text: 'admin@example.com');
  final passwordController = TextEditingController(text: 'Admin@123');

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final obscurePassword = true.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    final loginModel = LoginModel(
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
    );

    final bool result = await _loginRepo.login(loginModel);

    isLoading.value = false;

    if (result) {
      Get.offAllNamed(AppRoute.main);
    } else {
      errorMessage.value = 'Username or password is incorrect';
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}