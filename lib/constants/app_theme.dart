import 'package:flutter/material.dart';
import 'package:play_monti/constants/app_colors.dart';

class AppTheme {
  static ThemeData appTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.appBgColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBgColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.kButtonGreenColor),
    useMaterial3: true,
  );
}
