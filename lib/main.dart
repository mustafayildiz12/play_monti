import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:play_monti/constants/app_constants.dart';
import 'package:play_monti/constants/app_pages.dart';
import 'package:play_monti/constants/app_routes.dart';
import 'package:play_monti/constants/app_translation.dart';
import 'package:play_monti/firebase_options.dart';
import 'package:play_monti/service/authentication_service.dart';
import 'package:play_monti/service/database_service.dart';
import 'package:provider/provider.dart';
import 'contexts/user_context.dart';

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

  final User? user = authenticationService.getUser();

  if (user != null) {
    final bool isUserExist =
        await databaseService.getAdminBasicInfoFromRealTime(user.uid);
    if (isUserExist) {
      AppRoutes.initialRoute = AppRoutes.navigationBarPage;
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
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: GetMaterialApp(
        title: 'MontiTime',
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: const Locale('tr'), // Varsayılan dil
        fallbackLocale: const Locale('en'), // Yedek dil

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF91A88E)),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.activityDetailPage,
        getPages: AppPages.pages,
      ),
    ),
  );
}
