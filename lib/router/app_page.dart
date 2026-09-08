
import 'package:pro_23_g_3/screen/user/edit_user_screen.dart';
import 'package:get/get.dart';

import '../binding/auth_binding.dart';
import '../binding/main_binding.dart';
import '../binding/post_binding.dart';
import '../binding/splash_binding.dart';
import '../binding/user_binding.dart';
import '../screen/auth/login_screen.dart';

import '../screen/auth/register_screen.dart';
import '../screen/main_screen.dart';
import '../screen/post/create_post_screen.dart';
import '../screen/post/edit_post_screen.dart';
import '../screen/post/post_list_screen.dart';
import '../screen/splash/splash_screen.dart';
import '../screen/user/create_user_screen.dart';
import '../screen/user/user_detail_screen.dart';
import '../screen/user/user_list_screen.dart';
import 'app_route.dart';

class AppPage {
  const AppPage._();

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    // --- Splash ---
    GetPage<void>(
      name: AppRoute.splash,
      page: SplashScreen.new,
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),

    // --- Auth ---
    GetPage<void>(
      name: AppRoute.login,
      page: LoginScreen.new,
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage<void>(
      name: AppRoute.register,
      page: RegisterScreen.new,
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),

    // --- Main shell ---
    GetPage<void>(
      name: AppRoute.main,
      page: MainScreen.new,
      binding: MainBinding(),
      transition: Transition.fadeIn,
    ),

    // --- Posts ---
    GetPage<void>(
      name: AppRoute.postList,
      page: PostListScreen.new,
      binding: PostBinding(),
    ),
    GetPage<void>(
      name: AppRoute.postForm,
      page: CreatePostScreen.new,
      binding: PostBinding(),
    ),
    GetPage<void>(
      name: AppRoute.updateForm,
      page: EditPostScreen.new,
      binding: PostBinding(),
    ),

    // --- Users ---
    GetPage<void>(
      name: AppRoute.userList,
      page: UserListScreen.new,
      binding: UserBinding(),
    ),
    GetPage<void>(
      name: AppRoute.userCreateForm,
      page: CreateUserScreen.new,
      binding: UserBinding(),
    ),
    GetPage<void>(
      name: AppRoute.userUpdateForm,
      page: EditUserScreen.new,
      binding: UserBinding(),
    ),
    GetPage<void>(
      name: AppRoute.userDetail,
      page: UserDetailScreen.new,
      binding: UserBinding(),
    ),
  ];
}