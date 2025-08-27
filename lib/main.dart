import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:play_monti/constants/app_localization.dart';
import 'package:play_monti/constants/app_pages.dart';
import 'package:play_monti/constants/app_routes.dart';
import 'package:play_monti/constants/app_theme.dart';
import 'package:play_monti/constants/app_translation.dart';
import 'package:play_monti/service/app_init_service.dart';

Future<void> main() async {
  await AppInitService.initApp();

  runMyApp();
}

Future<void> runMyApp() async {
  runApp(
    GetMaterialApp(
      title: 'MontiTime',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: AppLocalization.locale, // Varsayılan dil
      fallbackLocale: AppLocalization.fallbackLocale, // Yedek dil
      supportedLocales: AppLocalization.supportedLocales,
      localizationsDelegates: AppLocalization.localizationsDelegates,
      theme: AppTheme.appTheme,
      initialRoute: AppRoutes.initialRoute,
      getPages: AppPages.pages,
    ),
  );
}
