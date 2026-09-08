import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/login_controller.dart';
import '../../core/value/app_color.dart';
import '../../router/app_route.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // =========================
              // Lock icon badge
              // =========================
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.primary,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'login_welcome'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textPrimary,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'login_subtitle'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColor.textSecondary),
              ),

              const SizedBox(height: 36),

              // =========================
              // Username
              // =========================
              _FieldLabel('username'.tr),
              const SizedBox(height: 8),
              TextField(
                controller: controller.usernameController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration(
                  hint: 'admin@example.com',
                  icon: Icons.mail_outline,
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // Password
              // =========================
              _FieldLabel('password'.tr),
              const SizedBox(height: 8),
              Obx(
                () => TextField(
                  controller: controller.passwordController,
                  obscureText: controller.obscurePassword.value,
                  decoration:
                      _inputDecoration(
                        hint: '••••••••',
                        icon: Icons.lock_outline,
                      ).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscurePassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColor.textSecondary,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                ),
              ),

              const SizedBox(height: 8),

              Obx(
                () => controller.errorMessage.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                            color: AppColor.danger,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 24),

              // =========================
              // Login button
              // =========================
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: controller.isLoading.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.login,
                            color: Colors.white,
                            size: 18,
                          ),
                    label: Text(
                      controller.isLoading.value ? 'logging in...'.tr : 'login'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // Register link
              // =========================
              TextButton(
                onPressed: () {
                  Get.toNamed(AppRoute.register);
                },
                child: Text(
                  'no_account_register'.tr,
                  style: TextStyle(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColor.textDisabled),
      prefixIcon: Icon(icon, color: AppColor.textSecondary),
      filled: true,
      fillColor: AppColor.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.primary, width: 1.5),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColor.textPrimary,
        ),
      ),
    );
  }
}
