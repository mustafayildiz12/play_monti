import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:play_monti/constants/app_translation.dart';
import 'package:play_monti/firebase_options.dart';
import 'package:play_monti/screens/Onboarding/onboarding_flow.dart';
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
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
        home: const OnboardingFlowScreen(),
      ),
    );
  }
}
