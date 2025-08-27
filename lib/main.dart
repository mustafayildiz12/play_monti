import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:play_monti/constants/app_constants.dart';
import 'package:play_monti/constants/app_localization.dart';
import 'package:play_monti/constants/app_pages.dart';
import 'package:play_monti/constants/app_routes.dart';
import 'package:play_monti/constants/app_theme.dart';
import 'package:play_monti/constants/app_translation.dart';
import 'package:play_monti/firebase_options.dart';
import 'package:play_monti/service/authentication_service.dart';
import 'package:play_monti/service/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'play-monti-firebase',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Gerekli servislerin başlatılması
  await Future.wait([
    GetStorage.init("local"),
    GetStorage.init("info"),
  ]);

  await initializeDateFormatting();

  final User? user = authenticationService.getUser();

  if (user != null) {
    final bool isUserExist =
        await databaseService.getAdminBasicInfoFromRealTime(user.uid);
    final bool isUserDetailExist =
        await databaseService.isUserDetailExist(user.uid);
    if (isUserExist) {
      if (isUserDetailExist) {
        AppRoutes.initialRoute = AppRoutes.navigationBarPage;
      } else {
        AppRoutes.initialRoute = AppRoutes.onboFlowPage;
      }
    } else {
      AppRoutes.initialRoute = AppRoutes.loginPage;
    }
  } else {
    bool isOnboSeen = infoStorage.read("onboarding") ?? false;

    if (isOnboSeen) {
      AppRoutes.initialRoute = AppRoutes.loginPage;
    } else {
      AppRoutes.initialRoute = AppRoutes.onboardingPage;
    }
  }

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
