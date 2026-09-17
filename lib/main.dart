import 'package:flutter/material.dart';
import 'package:pro_23_g_3/router/app_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pro_23_g_3/router/app_route.dart';
import 'package:pro_23_g_3/service/storage_service.dart';
import 'binding/initial_binding.dart';
import 'core/translations/app_translations.dart';
import 'core/value/app_color.dart';

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  final storage = Get.put(StorageService());
  final savedLocaleCode = await storage.getString('locale');

  final initialLocale = savedLocaleCode == 'km'
      ? const Locale('km', 'KH')
      : const Locale('en', 'US');
  runApp(MyApp(initialLocale: initialLocale));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialLocale});

  final Locale initialLocale;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColor.primary,
          onPrimary: AppColor.textPrimary,
          secondary: AppColor.primaryDark,
          onSecondary: Colors.white,
          surface: AppColor.surface,
          onSurface: AppColor.textPrimary,
          error: AppColor.danger,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: AppColor.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColor.surface,
          foregroundColor: AppColor.textPrimary,
          elevation: 0,
          centerTitle: true,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColor.primary,
        ),
      ),
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),

      locale: initialLocale,

      fallbackLocale: const Locale('en', 'US'),
      initialBinding: InitialBinding(),
      initialRoute: AppRoute.splash,
      getPages: AppPage.pages,
    );
  }
}



