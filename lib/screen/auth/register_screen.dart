import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/register_controller.dart';
import '../../core/value/app_color.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('create_account'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // Username
            // =========================
            _FieldLabel('username_email'.tr),
            const SizedBox(height: 8),
            TextField(
              controller: controller.usernameController,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration(
                hint: 'student@example.com',
                icon: Icons.mail_outline,
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // Nickname (optional)
            // =========================
            _FieldLabel('nickname_optional'.tr),
            const SizedBox(height: 8),
            TextField(
              controller: controller.nickNameController,
              decoration: _inputDecoration(
                hint: 'nickname_hint'.tr,
                icon: Icons.badge_outlined,
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
                decoration: _inputDecoration(
                  hint: 'Student@123',
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

            Text(
              'password_condition'.tr,
              style: TextStyle(fontSize: 12, color: AppColor.textSecondary),
            ),

            const SizedBox(height: 8),

            Obx(
                  () => controller.errorMessage.value.isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  controller.errorMessage.value,
                  style: TextStyle(color: AppColor.danger, fontSize: 12),
                ),
              )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),

            // =========================
            // Register button
            // =========================
            Obx(
                  () => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: controller.isLoading.value ? null : controller.register,
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
                      : const Icon(Icons.person_add_alt_1, color: Colors.white, size: 18),
                  label: Text(
                    controller.isLoading.value ? 'registering...'.tr : 'register'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon}) {
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
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColor.textPrimary,
      ),
    );
  }
}