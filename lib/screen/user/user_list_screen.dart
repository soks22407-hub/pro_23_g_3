import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_23_g_3/core/value/app_color.dart';

import '../../controller/user_controller.dart';
import '../../model/user_model.dart';
import '../../router/app_route.dart';
import '../widget/app_drawer.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  // Helper method to format relative creation time
  String _getCreatedTimeAgo(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final DateTime date = DateTime.parse(dateString).toLocal();
      final Duration diff = DateTime.now().difference(date);

      String timeAgo;
      if (diff.inDays >= 365) {
        timeAgo = '${diff.inDays ~/ 365} ${'years_ago'.tr}';
      } else if (diff.inDays >= 30) {
        timeAgo = '${diff.inDays ~/ 30} ${'months_ago'.tr}';
      } else if (diff.inDays > 0) {
        timeAgo = '${diff.inDays} ${'days_ago'.tr}';
      } else if (diff.inHours > 0) {
        timeAgo = '${diff.inHours} ${'hours_ago'.tr}';
      } else if (diff.inMinutes > 0) {
        timeAgo = '${diff.inMinutes} ${'minutes_ago'.tr}';
      } else {
        timeAgo = 'just_now'.tr;
      }

      return '${'create'.tr} $timeAgo';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.find<UserController>();

    final RxString searchText = ''.obs;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: Text('users'.tr), centerTitle: true),
      body: Obx(() {
        // =========================
        // Loading
        // =========================
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // =========================
        // Error
        // =========================
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        // =========================
        // Filter users
        // =========================
        final List<UserModel> filteredUsers = controller.users.where((user) {
          final String username = user.username?.toLowerCase() ?? '';
          final String nickName = user.nickName?.toLowerCase() ?? '';
          final String search = searchText.value.toLowerCase();

          return username.contains(search) || nickName.contains(search);
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
                  hintText: 'search_by_username'.tr,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            // =========================
            // Pagination
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'shown_count'.trParams({
                    'shown': controller.users.length.toString(),
                    'total': controller.total.toString(),
                  }),
                ),
              ),
            ),

            // =========================
            // User List
            // =========================
            Expanded(
              child: filteredUsers.isEmpty
                  ? RefreshIndicator(
                onRefresh: controller.loadFirstPage,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 300,
                      child: Center(child: Text('no_users_found'.tr)),
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
                    filteredUsers.length +
                        (controller.isLoadingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      // =========================
                      // Loading more
                      // =========================
                      if (index == filteredUsers.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final UserModel user = filteredUsers[index];
                      final String createdText =
                      _getCreatedTimeAgo(user.createdAt);

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
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
                          onTap: () {
                            Get.toNamed(
                              AppRoute.userDetail,
                              arguments: user,
                            );
                          },

                          // =========================
                          // Avatar
                          // =========================
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColor.border, width: 1.5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: user.imageUrl != null && user.imageUrl!.isNotEmpty
                                  ? Image.network(
                                user.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _InitialsAvatar(user: user);
                                },
                              )
                                  : _InitialsAvatar(user: user),
                            ),
                          ),

                          // =========================
                          // Name + Status
                          // =========================
                          title: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  user.nickName?.isNotEmpty == true
                                      ? user.nickName!
                                      : (user.username ?? ''),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (!(user.enabled ?? true)) ...[
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
                                    'disabled'.tr,
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
                          // Username + Created Relative Time
                          // =========================
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),

                              Text(
                                user.username ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),

                              if (createdText.isNotEmpty) ...[
                                const SizedBox(height: 3),
                                Text(
                                  createdText,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ],
                          ),

                          // =========================
                          // Menu
                          // =========================
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) {
                              if (value == 'edit') {
                                Get.toNamed(
                                  '/edit-user',
                                  arguments: user,
                                );
                              }

                              if (value == 'toggle_enabled') {
                                controller.toggleEnabled(user);
                              }

                              if (value == 'delete') {
                                Get.defaultDialog(
                                  title: 'delete_user_title'.tr,
                                  middleText: 'delete_user_confirm'.tr,
                                  textConfirm: 'delete'.tr,
                                  textCancel: 'cancel'.tr,
                                  cancelTextColor: Colors.black,
                                  confirmTextColor: Colors.white,
                                  buttonColor: Colors.red,
                                  onConfirm: () {
                                    Get.back();
                                    controller.deleteUser(user);
                                  },
                                );
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    const Icon(Icons.edit, size: 20),
                                    const SizedBox(width: 30),
                                    Text('edit'.tr),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'toggle_enabled',
                                child: Row(
                                  children: [
                                    Icon(
                                      (user.enabled ?? true)
                                          ? Icons.block
                                          : Icons.check_circle_outline,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 30),
                                    Text(
                                      (user.enabled ?? true)
                                          ? 'disable'.tr
                                          : 'enable'.tr,
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
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

      // =========================
      // New User
      // =========================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed('/create-user');
        },
        backgroundColor: AppColor.primaryLight,
        icon: const Icon(Icons.add),
        label: Text('new_user'.tr),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.user});

  final UserModel user;

  String get _initials {
    final String source =
    (user.nickName?.isNotEmpty == true
        ? user.nickName!
        : (user.username ?? ''))
        .trim();

    if (source.isEmpty) return '?';

    final List<String> parts = source.split(RegExp(r'\s+'));

    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }

    return source.length >= 2
        ? source.substring(0, 2).toUpperCase()
        : source.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColor.primaryLight,
      child: Center(
        child: Text(
          _initials,
          style: const TextStyle(
            color: AppColor.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}