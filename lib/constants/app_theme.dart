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
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.kButtonGreenColor),
    useMaterial3: true,
    // Varsayılan font (tüm body text, buton, caption vs.)
    fontFamily: 'Nunito',

    textTheme: const TextTheme(
      // Başlıklar için ComicNeue
      displayLarge:
          TextStyle(fontFamily: 'ComicNeue', fontWeight: FontWeight.bold),
      displayMedium:
          TextStyle(fontFamily: 'ComicNeue', fontWeight: FontWeight.bold),
      displaySmall:
          TextStyle(fontFamily: 'ComicNeue', fontWeight: FontWeight.bold),
      headlineLarge:
          TextStyle(fontFamily: 'ComicNeue', fontWeight: FontWeight.bold),
      headlineMedium:
          TextStyle(fontFamily: 'ComicNeue', fontWeight: FontWeight.bold),
      headlineSmall:
          TextStyle(fontFamily: 'ComicNeue', fontWeight: FontWeight.bold),
      titleLarge:
          TextStyle(fontFamily: 'ComicNeue', fontWeight: FontWeight.bold),
      titleMedium:
          TextStyle(fontFamily: 'ComicNeue', fontWeight: FontWeight.w600),
      titleSmall:
          TextStyle(fontFamily: 'ComicNeue', fontWeight: FontWeight.w600),

      // Body ve diğer textler varsayılan Nunito'dan gelecek
    ),
  );
}
