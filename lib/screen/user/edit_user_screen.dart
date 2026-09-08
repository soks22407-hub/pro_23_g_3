import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/user_controller.dart';
import '../../core/value/app_color.dart';
import '../../model/user_model.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final UserController controller = Get.find<UserController>();

  late final UserModel user;
  late final TextEditingController usernameController;
  late final TextEditingController nickNameController;
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

  @override
  void initState() {
    super.initState();
    user = Get.arguments as UserModel;
    usernameController = TextEditingController(text: user.username ?? '');
    nickNameController = TextEditingController(text: user.nickName ?? '');
  }

  @override
  void dispose() {
    usernameController.dispose();
    nickNameController.dispose();
    super.dispose();
  }

  void submit() {
    controller.updateUser(
      user: user,
      username: usernameController.text.trim(),
      nickName: nickNameController.text.trim(),
      newImage: pickedImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit_user'.tr),
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
                  child: ClipOval(
                    child: pickedImage != null
                        ? Image.file(
                      pickedImage!,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                    )
                        : (user.imageUrl != null && user.imageUrl!.isNotEmpty
                        ? Image.network(
                      user.imageUrl!,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person_outline,
                          size: 48,
                          color: AppColor.primaryDark,
                        );
                      },
                    )
                        : Icon(
                      Icons.person_outline,
                      size: 48,
                      color: AppColor.primaryDark,
                    )),
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

            GestureDetector(
              onTap: pickImage,
              child: Text(
                'tap_to_replace_photo'.tr,
                style: TextStyle(fontSize: 13, color: AppColor.textSecondary),
              ),
            ),

            const SizedBox(height: 24),

            // =========================
            // Username (read-only)
            // =========================
            _FieldLabel('username_email'.tr),
            const SizedBox(height: 8),
            TextField(
              controller: usernameController,
              decoration: _inputDecoration(
                hint: 'user@gmail.com',
                icon: Icons.mail_outline,
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // Nickname (editable)
            // =========================
            _FieldLabel('nickname'.tr),
            const SizedBox(height: 8),
            TextField(
              controller: nickNameController,
              decoration: _inputDecoration(
                hint: 'enter_nickname'.tr,
                icon: Icons.badge_outlined,
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // Save
            // =========================
            Obx(
                  () => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: controller.isUpdating.value ? null : submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: controller.isUpdating.value
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
                    controller.isUpdating.value
                        ? 'updating'.tr
                        : 'update'.tr,
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
