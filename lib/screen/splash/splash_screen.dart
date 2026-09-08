import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/splash_controller.dart';
import '../../core/value/app_color.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('SPLASH SCREEN BUILD CALLED');
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_alt,
              size: 64,
              color: AppColor.primary,
            ),

            const SizedBox(height: 16),

            Text(
              'app_name'.tr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor.textPrimary,
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColor.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}