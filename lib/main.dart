import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:play_monti/constants/app_translation.dart';
import 'package:play_monti/firebase_options.dart';
import 'package:play_monti/screens/Onboarding/onboarding_flow.dart';
import 'package:play_monti/screens/tab_screens.dart';
import 'package:provider/provider.dart';
import 'contexts/user_context.dart';
import 'screens/onboarding_flow.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        home:  const OnboardingFlowScreen(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showOnboarding = true;

  void _onOnboardingComplete() {
    setState(() {
      _showOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return OnboardingFlow(onComplete: _onOnboardingComplete);
    }

    // Main app content after onboarding
    return Scaffold(
      appBar: AppBar(
        title: const Text('MontiTime'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final userData = userProvider.userData;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to MontiTime!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if (userData != null) ...[
                  Text('Name: ${userData.name}'),
                  Text('Language: ${userData.language}'),
                  Text('Age Group: ${userData.ageGroup}'),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    userProvider.clearUserData();
                    setState(() {
                      _showOnboarding = true;
                    });
                  },
                  child: const Text('Restart Onboarding'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainTabNavigator()),
                        (r) => false);
                  },
                  child: const Text('Start'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
