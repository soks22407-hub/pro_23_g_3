import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_23_g_3/core/value/app_color.dart';

import '../../controller/post_controller.dart';
import '../../model/post_daa_model.dart';

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  // Helper method to format relative time
  String _getTimeAgo(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final DateTime date = DateTime.parse(dateString).toLocal();
      final Duration diff = DateTime.now().difference(date);

      if (diff.inDays >= 365) return '${diff.inDays ~/ 365} ${'years_ago'.tr}';
      if (diff.inDays >= 30) return '${diff.inDays ~/ 30} ${'months_ago'.tr}';
      if (diff.inDays > 0) return '${diff.inDays} ${'days_ago'.tr}';
      if (diff.inHours > 0) return '${diff.inHours} ${'hours_ago'.tr}';
      if (diff.inMinutes > 0) return '${diff.inMinutes} ${'minutes_ago'.tr}';
      return 'just_now'.tr;
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final PostController controller = Get.find<PostController>();

    // Search text
    final RxString searchText = ''.obs;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('posts'.tr), centerTitle: true),

      body: Obx(() {
        // Loading
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        // Filter posts
        final List<PostDataModel> filteredPosts = controller.posts.where((
            post,
            ) {
          final String title = post.title?.toLowerCase() ?? '';
          final String content = post.content?.toLowerCase() ?? '';
          final String search = searchText.value.toLowerCase();

          return title.contains(search) || content.contains(search);
        }).toList();

        return Column(
          children: [
            // =========================
            // Search
            // =========================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                onChanged: (value) {
                  searchText.value = value;
                },
                decoration: InputDecoration(
                  hintText: 'search_by_title'.tr,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            // Paginate status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'shown_count'.trParams({
                    'shown': controller.posts.length.toString(),
                    'total': controller.total.toString(),
                  }),
                ),
              ),
            ),

            // =========================
            // Post List
            // =========================
            Expanded(
              child: filteredPosts.isEmpty
                  ? RefreshIndicator(
                onRefresh: controller.loadFirstPage,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 300,
                      child: Center(child: Text('no_posts_found'.tr)),
                    ),
                  ],
                ),
              )
                  : RefreshIndicator(
                onRefresh: controller.loadFirstPage,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 300) {
                      controller.loadNextPage();
                    }

                    return false;
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount:
                    filteredPosts.length +
                        (controller.isLoadingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      // =========================
                      // Loading more
                      // =========================
                      if (index == filteredPosts.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final PostDataModel post = filteredPosts[index];
                      final String authorName = post.author?.nickName ??
                          post.author?.username ??
                          'Unknown';
                      final String timeAgo = _getTimeAgo(post.createdAt);

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),

                          // =========================
                          // Image
                          // =========================
                          leading: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: 58,
                                height: 100,
                                child:
                                post.imageUrl != null &&
                                    post.imageUrl!.isNotEmpty
                                    ? Image.network(
                                  post.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return const ColoredBox(
                                      color:
                                      AppColor.primaryLight,
                                      child: Icon(
                                        Icons.article_outlined,
                                        color: AppColor.primary,
                                      ),
                                    );
                                  },
                                )
                                    : const ColoredBox(
                                  color: AppColor.primaryLight,
                                  child: Icon(
                                    Icons.article_outlined,
                                    color: AppColor.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // =========================
                          // Title + Status Badge
                          // =========================
                          title: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  post.title ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (!(post.published ?? false)) ...[
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.dangerLight,
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                    border: Border.all(
                                      color: AppColor.dangerLight,
                                    ),
                                  ),
                                  child: Text(
                                    'draft'.tr,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.danger,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),

                          // =========================
                          // Content + Author & Relative Time
                          // =========================
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (post.content != null &&
                                  post.content!.trim().isNotEmpty) ...[
                                const SizedBox(height: 3),

                                Text(
                                  post.content!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                ),

                                const SizedBox(height: 3),
                              ],

                              // Author Name · Relative Time
                              Text(
                                '$authorName${timeAgo.isNotEmpty ? ' · $timeAgo' : ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) {
                              if (value == 'edit') {
                                Get.toNamed(
                                  '/edit-post',
                                  arguments: post,
                                );
                              } else if (value == 'toggle_publish') {
                                controller.togglePublish(post);
                              } else if (value == 'delete') {
                                Get.defaultDialog(
                                  title: 'delete_post_title'.tr,
                                  middleText: 'delete_post_confirm'.tr,
                                  textConfirm: 'delete'.tr,
                                  textCancel: 'cancel'.tr,
                                  cancelTextColor: Colors.black,
                                  confirmTextColor: Colors.white,
                                  buttonColor: Colors.red,
                                  onConfirm: () {
                                    Get.back();
                                    controller.deletePost(post);
                                  },
                                );
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    const Icon(Icons.edit, size: 20),
                                    const SizedBox(width: 30),
                                    Text('edit'.tr),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'toggle_publish',
                                child: Row(
                                  children: [
                                    Icon(
                                      (post.published ?? false)
                                          ? Icons.visibility_off_outlined
                                          : Icons.remove_red_eye_outlined,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 30),
                                    Text(
                                      (post.published ?? false)
                                          ? 'unpublic'.tr
                                          : 'public'.tr,
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 30),
                                    Text('delete'.tr),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      }),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed('/create-post');
        },
        backgroundColor: AppColor.primaryLight,
        icon: const Icon(Icons.add),
        label: Text('new_post'.tr),
      ),
    );
  }
}