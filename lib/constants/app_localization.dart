import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';

class AppLocalization {
  static Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates =
      const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate
  ];

  static List<Locale> supportedLocales = const [Locale("tr"), Locale("en")];

  static Locale locale = const Locale("tr");
  static Locale fallbackLocale = const Locale("en");

  /// Cihaz dili (uygulamanın dili değil)
  static String get deviceLanguageCode =>
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;

  /// Uygulamanın *şu anki* dili (GetX tarafından yönetilen)
  static String get currentLangCode =>
      Get.locale?.languageCode ?? Get.deviceLocale?.languageCode ?? 'en';

  /// API path vb. için dinamik param
  static String get getLanguageCodeParam => '/$currentLangCode';
}
