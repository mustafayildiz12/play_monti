import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:play_monti/constants/app_routes.dart';
import 'package:play_monti/screens/Auth/login_screen.dart';
import 'package:play_monti/screens/Auth/register_page.dart';
import 'package:play_monti/screens/ExcelActivity/upload_activity_excel.dart';
import 'package:play_monti/screens/Home/ActivityDetail/activity_detail_page.dart';
import 'package:play_monti/screens/Onboarding/onboarding_flow.dart';
import 'package:play_monti/screens/onboarding_flow.dart';
import 'package:play_monti/screens/tab_screens.dart';

class AppPages {
  static List<GetPage<dynamic>>? pages = [
    GetPage(
        name: AppRoutes.uploadActivityPage, page: () => const UploadActivityExcel()),
    GetPage(
      name: AppRoutes.loginPage,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: AppRoutes.registerPage,
      page: () => const RegisterPage(),
    ),
    GetPage(
      name: AppRoutes.onboardingPage,
      page: () => const OnboardingFlowScreen(),
    ),
    GetPage(
      name: AppRoutes.onboFlowPage,
      page: () => const OnboardingFlow(),
    ),
    GetPage(
      name: AppRoutes.navigationBarPage,
      page: () => const MainTabNavigator(),
    ),
    GetPage(
      name: "${AppRoutes.activityDetailPage}/:id/:date",
      page: () => const ActivityDetailPage(),
    ),
  ];
}
