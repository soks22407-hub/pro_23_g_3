import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/util/api_exception.dart';
import '../../core/value/app_color.dart';
import '../../model/user_model.dart';
import '../../repository/user_repository.dart';
import '../../router/app_route.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final UserRepository _userRepo = Get.find<UserRepository>();

  UserModel? currentUser;
  bool isOnline = true;
  Timer? _connectivityTimer;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _checkInternetConnection();
    // Periodically check connection status every 5 seconds
    _connectivityTimer = Timer.periodic(
      const Duration(seconds: 5),
          (_) => _checkInternetConnection(),
    );
  }

  @override
  void dispose() {
    _connectivityTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      final connected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      if (mounted && isOnline != connected) {
        setState(() => isOnline = connected);
      }
    } on SocketException catch (_) {
      if (mounted && isOnline != false) {
        setState(() => isOnline = false);
      }
    }
  }

  Future<void> _loadProfile() async {
    try {
      final user = await _userRepo.getProfile();
      if (mounted) setState(() => currentUser = user);
    } on ApiException catch (_) {
      // Silently ignore — drawer just keeps showing the placeholder.
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasPhoto =
        currentUser?.imageUrl != null && currentUser!.imageUrl!.isNotEmpty;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Header Profile Area
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                  color: AppColor.primary,
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: hasPhoto
                                ? Image.network(
                              currentUser!.imageUrl!,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _InitialsAvatar(user: currentUser!);
                              },
                            )
                                : _InitialsAvatar(user: currentUser),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          currentUser?.nickName?.isNotEmpty == true
                              ? currentUser!.nickName!
                              : (currentUser?.username ?? 'GetX Basic'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentUser?.username ?? 'admin@example.com',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(AppRoute.userList);
                  },
                  leading: const Icon(
                    Icons.people_outline,
                    color: Colors.black,
                    size: 30,
                  ),
                  title: Text(
                    "users".tr,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(AppRoute.userCreateForm);
                  },
                  leading: const Icon(
                    Icons.person_add_alt_1_outlined,
                    color: Colors.black,
                    size: 30,
                  ),
                  title: Text(
                    "new user".tr,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const Divider(height: 3, color: Colors.black12),
                ListTile(
                  onTap: () {
                    setState(() {
                      if (Get.locale?.languageCode == 'en') {
                        Get.updateLocale(const Locale('km', 'KH'));
                      } else {
                        Get.updateLocale(const Locale('en', 'US'));
                      }
                    });
                    Navigator.pop(context);
                  },
                  leading: const Icon(
                    Icons.translate,
                    color: Colors.black,
                    size: 30,
                  ),
                  title: Text(
                    "language".tr,
                    style: const TextStyle(color: AppColor.textPrimary),
                  ),
                  trailing: Text(
                    Get.locale?.languageCode == 'km' ? 'ខ្មែរ' : 'English',
                    style: const TextStyle(color: AppColor.primary),
                  ),
                ),


                ListTile(
                  onTap: () {
                    _checkInternetConnection();
                  },
                  leading: Icon(
                    isOnline ? Icons.wifi : Icons.wifi_off,
                    color: isOnline ? AppColor.textPrimary : AppColor.danger,
                    size: 30,
                  ),
                  title: Text(
                    "connection".tr,
                    style: const TextStyle(color: AppColor.textPrimary),
                  ),
                  trailing: Text(
                    isOnline ? "online".tr : "offline".tr,
                    style: TextStyle(
                      color: isOnline ? AppColor.primary : AppColor.danger,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Colors.black12),

          // Logout
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Get.defaultDialog(
                title: 'logout'.tr,
                middleText: 'logout_confirm'.tr,
                textConfirm: 'logout'.tr,
                textCancel: 'cancel'.tr,
                cancelTextColor: Colors.black,
                confirmTextColor: Colors.white,
                buttonColor: AppColor.danger,
                onConfirm: () {
                  Get.back();
                  Get.offAllNamed(AppRoute.login);
                },
              );
            },
            leading: const Icon(Icons.logout, color: AppColor.danger, size: 30),
            title: Text(
              "logout".tr,
              style: const TextStyle(color: AppColor.danger),
            ),
          ),
        ],
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.user});

  final UserModel? user;

  String get _initials {
    final String source = (user?.nickName?.isNotEmpty == true
        ? user!.nickName!
        : (user?.username ?? ''))
        .trim();

    if (source.isEmpty) return 'AD';

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
    return SizedBox(
      width: 70,
      height: 70,
      child: ColoredBox(
        color: Colors.white,
        child: Center(
          child: Text(
            _initials,
            style: const TextStyle(
              color: AppColor.primary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }
}