import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/post_controller.dart';
import '../../core/value/app_color.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<CreatePostScreen> {
  final PostController controller = Get.find<PostController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  File? selectedImage;

  // true = Public
  // false = Unpublic
  bool published = true;

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  // =========================
  // Pick Image
  // =========================
  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile == null) {
        return;
      }

      setState(() {
        selectedImage = File(pickedFile.path);
      });
    } catch (e) {
      debugPrint('IMAGE PICKER ERROR: $e');

      Get.snackbar(
        'error'.tr,
        'Could not select image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // =========================
  // Create Post
  // =========================
  void createPost() {
    controller.createPost(
      title: titleController.text,
      content: contentController.text,
      published: published,
      image: selectedImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('new_post'.tr), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // 1. Title
            // =========================
            Text(
              'title'.tr,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: titleController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'enter_post_title'.tr,
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // 2. Content
            // =========================
            Text(
              'content'.tr,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'write_your_post'.tr,
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // 3. Image Box
            // =========================
            Text(
              'image'.tr,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: AppColor.primaryLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: selectedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 48,
                            color: AppColor.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'tap_to_select_image'.tr,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          selectedImage!,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),

            // Remove image button
            if (selectedImage != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedImage = null;
                    });
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: Text(
                    'remove_image'.tr,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // =========================
            // 4. Visibility Toggle Switch
            // =========================
            SwitchListTile(
              value: published,
              onChanged: (value) {
                setState(() {
                  published = value;
                });
              },
              title: Text(
                'published'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                published ? 'published_subtitle'.tr : 'unpublished_subtitle'.tr,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              activeColor: Colors.white,
              activeTrackColor: AppColor.primary,
              contentPadding: EdgeInsets.zero,
            ),

            const SizedBox(height: 30),

            // =========================
            // 5. Create Button
            // =========================
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: controller.isCreating.value ? null : createPost,
                  icon: controller.isCreating.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check),
                  label: Text(
                    controller.isCreating.value
                        ? 'creating'.tr
                        : 'create_post'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
