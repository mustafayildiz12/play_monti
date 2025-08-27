import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:play_monti/constants/app_colors.dart';

class AppTheme {
  static ThemeData appTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.appBgColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBgColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.appBgColor, // Status bar arka planı
        statusBarIconBrightness: Brightness.dark, // Android ikonları beyaz
        statusBarBrightness: Brightness.dark,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.kButtonGreenColor),
    useMaterial3: true,
  );
}
