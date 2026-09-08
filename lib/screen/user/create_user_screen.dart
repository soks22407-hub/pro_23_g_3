import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/user_controller.dart';
import '../../core/value/app_color.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final UserController controller = Get.find<UserController>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  File? pickedImage;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file == null) return;
    setState(() => pickedImage = File(file.path));
  }

  void submit() {
    controller.createUser(
      username: usernameController.text.trim(),
      nickName: nickNameController.text.trim(),
      password: passwordController.text,
      image: pickedImage,
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    nickNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('new_user'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // =========================
            // Avatar + camera badge
            // =========================
            Stack(
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.primaryLight,
                  ),
                  child: pickedImage != null
                      ? ClipOval(
                    child: Image.file(
                      pickedImage!,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Icon(
                    Icons.person_outline,
                    size: 48,
                    color: AppColor.primaryDark,
                  ),
                ),
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.primary,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              'photo_upload_note'.tr,
              style: TextStyle(fontSize: 12, color: AppColor.textSecondary),
            ),

            const SizedBox(height: 24),

            // =========================
            // Username
            // =========================
            _FieldLabel('username_email'.tr),
            const SizedBox(height: 8),
            TextField(
              controller: usernameController,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration(
                hint: 'student@example.com',
                icon: Icons.mail_outline,
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // Nickname
            // =========================
            _FieldLabel('nickname'.tr),
            const SizedBox(height: 8),
            TextField(
              controller: nickNameController,
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
            TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: _inputDecoration(
                hint: 'Student@123',
                icon: Icons.lock_outline,
              ).copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColor.textSecondary,
                  ),
                  onPressed: () {
                    setState(() => obscurePassword = !obscurePassword);
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // Submit
            // =========================
            Obx(
                  () => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: controller.isCreating.value ? null : submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: controller.isCreating.value
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.check, color: Colors.white),
                  label: Text(
                    controller.isCreating.value
                        ? 'creating'.tr
                        : 'create_user'.tr,
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
