import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/post_controller.dart';
import '../../core/value/app_color.dart';
import '../../model/post_daa_model.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen({super.key});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final PostController controller = Get.find<PostController>();

  late final PostDataModel post;
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late bool published;
  File? newImage;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    setState(() {
      newImage = File(pickedFile.path);
    });
  }

  @override
  void initState() {
    super.initState();
    post = Get.arguments as PostDataModel;
    titleController = TextEditingController(text: post.title ?? '');
    contentController = TextEditingController(text: post.content ?? '');
    published = post.published ?? false;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void submitEdit() {
    controller.updatePost(
      post: post,
      title: titleController.text,
      content: contentController.text,
      published: published,
      newImage: newImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit_user'.tr), // កែសម្រួលអត្ថបទ
        centerTitle: true,
      ),

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
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'write_your_post'.tr,
                alignLabelWithHint: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 95),
                  child: Icon(Icons.description_outlined),
                ),
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
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  color: AppColor.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: newImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    newImage!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                )
                    : (post.imageUrl != null && post.imageUrl!.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    post.imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                      );
                    },
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 55,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'tap_to_replace_photo'.tr,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                )),
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // 4. Visibility Switch
            // =========================
            Text(
              'visibility'.tr,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                value: published,
                onChanged: (value) {
                  setState(() {
                    published = value;
                  });
                },
                title: Text(
                  'published'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  published
                      ? 'published_subtitle'.tr
                      : 'unpublished_subtitle'.tr,
                ),
                activeColor: Colors.white,
                activeTrackColor: AppColor.primary,
                contentPadding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // 5. Save Button
            // =========================
            Obx(
                  () => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: controller.isUpdating.value ? null : submitEdit,
                  icon: controller.isUpdating.value
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.save),
                  label: Text(
                    controller.isUpdating.value
                        ? 'updating'.tr
                        : 'update'.tr,
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