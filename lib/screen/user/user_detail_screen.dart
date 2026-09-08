import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/value/app_color.dart';
import '../../model/user_model.dart';
import '../../router/app_route.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key});

  String _formatDate(String? iso) {
    if (iso == null) return '';
    try {
      final DateTime dt = DateTime.parse(iso).toLocal();
      return DateFormat('dd MMM yyyy · HH:mm').format(dt);
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Get.arguments as UserModel;
    final bool enabled = user.enabled ?? true;

    return Scaffold(
      appBar: AppBar(title: Text('user_detail'.tr), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // =========================
            // Avatar
            // =========================
            ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: Container(
                width: 90,
                height: 90,
                color: AppColor.primaryLight,
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

            const SizedBox(height: 14),

            Text(
              user.nickName?.isNotEmpty == true
                  ? user.nickName!
                  : (user.username ?? ''),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text(
              user.username ?? '',
              style: TextStyle(fontSize: 14, color: AppColor.textSecondary),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: enabled ? AppColor.successLight : AppColor.dangerLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                enabled ? 'enabled'.tr : 'disabled'.tr,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: enabled ? AppColor.success : AppColor.danger,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // =========================
            // Detail rows
            // =========================
            _DetailRow(label: 'id'.tr, value: '${user.id ?? ''}'),
            _DetailRow(label: 'username'.tr, value: user.username ?? ''),
            _DetailRow(label: 'nickname'.tr, value: user.nickName ?? ''),
            _DetailRow(label: 'image_file'.tr, value: user.imageName ?? '—'),
            _DetailRow(label: 'created'.tr, value: _formatDate(user.createdAt)),
            _DetailRow(
              label: 'updated'.tr,
              value: _formatDate(user.updatedAt),
              showDivider: false,
            ),

            const SizedBox(height: 30),

            // =========================
            // Edit button
            // =========================
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(AppRoute.userUpdateForm, arguments: user);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                label: Text(
                  'edit'.tr,
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 90,
                child: Text(
                  label,
                  style: TextStyle(fontSize: 13, color: AppColor.textSecondary),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, color: AppColor.border),
      ],
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.user});

  final UserModel user;

  String get _initials {
    final String source = (user.nickName?.isNotEmpty == true
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
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
