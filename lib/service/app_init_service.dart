import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:play_monti/constants/app_constants.dart';
import 'package:play_monti/constants/app_localization.dart';
import 'package:play_monti/constants/app_routes.dart';
import 'package:play_monti/firebase_options.dart';
import 'package:play_monti/service/authentication_service.dart';
import 'package:play_monti/service/database_service.dart';
import 'package:play_monti/service/in_app_purchase_service.dart';

class AppInitService {
  static Future<void> initApp() async {
    await init();
    await initLocale();
    await initPurchase();
    await initRoute();
  }

  static initPurchase() async {
    final iap = InAppPurchaseService();
    await iap.initPlatformState(); // ÖNEMLİ: await
  }

  static Future<void> init() async {
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
  }

  static Future<void> initRoute() async {
    final User? user = authenticationService.getUser();

    if (user != null) {
      final bool isUserExist =
          await databaseService.getAdminBasicInfoFromRealTime(user.uid);
      final bool isUserDetailExist =
          await databaseService.isUserDetailExist(user.uid);
      if (isUserExist) {
        if (isUserDetailExist) {
          bool isUserPremium = InAppPurchaseService().checkUserHaveProduct();
          if (isUserPremium) {
            AppRoutes.initialRoute = AppRoutes.navigationBarPage;
          } else {
            AppRoutes.initialRoute = AppRoutes.trialPage;
          }
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
  }

  static Future<void> initLocale() async {
    String? languageCode = infoStorage.read("languageCode");

    if (languageCode != null) {
      AppLocalization.locale = Locale(languageCode);
    } else {
      Locale deviceLocale = pickBestLocaleFromDevice();
      AppLocalization.locale = deviceLocale;
      await infoStorage.write("languageCode", deviceLocale.languageCode);
    }
  }

  static Locale pickBestLocaleFromDevice() {
    final locales = WidgetsBinding.instance.platformDispatcher.locales;

    // 1) Tercihlerde TR var mı?
    final tr = locales.firstWhere(
      (l) => l.languageCode.toLowerCase() == 'tr',
      orElse: () => const Locale('und'),
    );
    if (tr.languageCode != 'und') return const Locale('tr');

    // 2) Tercihlerde EN var mı?
    final en = locales.firstWhere(
      (l) => l.languageCode.toLowerCase() == 'en',
      orElse: () => const Locale('und'),
    );
    if (en.languageCode != 'und') return const Locale('en');

    // 3) Emniyet: TR
    return const Locale('tr');
  }
}
