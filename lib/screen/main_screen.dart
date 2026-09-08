import 'package:flutter/material.dart';
import 'package:pro_23_g_3/core/value/app_color.dart';
import 'package:pro_23_g_3/screen/auth/login_screen.dart';
import 'package:pro_23_g_3/screen/home/home_screen.dart';
import 'package:pro_23_g_3/screen/post/post_list_screen.dart';
import 'package:pro_23_g_3/screen/post/post_screen.dart';
import 'package:pro_23_g_3/screen/setting/setting_screen.dart';
import 'package:pro_23_g_3/screen/user/user_list_screen.dart';
import 'package:pro_23_g_3/screen/user/user_screen.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [HomeScreen(), PostListScreen(), UserListScreen(), SettingScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        indicatorColor: AppColor.primary,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'home'.tr,
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article),
            label: 'post'.tr,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'user'.tr,
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'setting'.tr,
          ),
        ],
      ),
    );
  }
}
