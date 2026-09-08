import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/util/api_exception.dart';
import '../../core/value/app_color.dart';
import '../../model/user_model.dart';
import '../../repository/user_repository.dart';
import '../../router/app_route.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final UserRepository _userRepo = Get.find<UserRepository>();

  UserModel? currentUser;
  bool loadingProfile = true;
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
      if (mounted) {
        setState(() {
          currentUser = user;
          loadingProfile = false;
        });
      }
    } on ApiException catch (_) {
      if (mounted) setState(() => loadingProfile = false);
    }
  }

  Future<void> _goToEditProfile() async {
    if (currentUser != null) {
      Get.toNamed(AppRoute.userUpdateForm, arguments: currentUser);
      return;
    }
    try {
      final user = await _userRepo.getProfile();
      Get.toNamed(AppRoute.userUpdateForm, arguments: user);
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasPhoto =
        currentUser?.imageUrl != null && currentUser!.imageUrl!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text('setting'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // Signed-in-as card
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    backgroundImage: hasPhoto
                        ? NetworkImage(currentUser!.imageUrl!)
                        : const AssetImage('assets/images/profile.webp')
                    as ImageProvider,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'signed_in_as'.tr,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          loadingProfile
                              ? 'Loading...'
                              : (currentUser?.nickName?.isNotEmpty == true
                              ? currentUser!.nickName!
                              : (currentUser?.username ?? 'Admin')),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          currentUser?.username ?? '',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // =========================
            // Your account
            // =========================
            _SectionLabel('your_account'.tr),
            const SizedBox(height: 4),
            _SettingTile(
              icon: Icons.edit_outlined,
              title: 'edit_profile'.tr,
              subtitle: 'edit_profile_subtitle'.tr,
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: _goToEditProfile,
            ),

            const SizedBox(height: 30),

            // =========================
            // Preferences
            // =========================
            _SectionLabel('preferences'.tr),
            const SizedBox(height: 4),
            _SettingTile(
              icon: Icons.translate,
              title: 'language'.tr,
              subtitle: 'switch_language'.tr,
              highlighted: true,
              trailing: Text(
                Get.locale?.languageCode == 'km' ? 'ខ្មែរ' : 'English',
                style: const TextStyle(
                  color: AppColor.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                setState(() {
                  if (Get.locale?.languageCode == 'en') {
                    Get.updateLocale(const Locale('km', 'KH'));
                  } else {
                    Get.updateLocale(const Locale('en', 'US'));
                  }
                });
              },
            ),
            _SettingTile(
              icon: isOnline ? Icons.wifi : Icons.wifi_off,
              iconColor: isOnline ? AppColor.textSecondary : AppColor.danger,
              title: 'connection'.tr,
              onTap: _checkInternetConnection,
              trailing: Text(
                isOnline ? 'online'.tr : 'offline'.tr,
                style: TextStyle(
                  color: isOnline ? AppColor.primary : AppColor.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // About
            // =========================
            _SectionLabel('about'.tr),
            const SizedBox(height: 4),
            _SettingTile(
              icon: Icons.info_outline,
              title: 'version'.tr,
              trailing: const Text(
                '1.0.0',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // Logout
            // =========================
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.danger,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout, color: Colors.white, size: 18),
                label: Text(
                  'logout'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: AppColor.textSecondary,
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.title,
    this.iconColor,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlighted ? AppColor.background : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? AppColor.textSecondary,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 15),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColor.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}