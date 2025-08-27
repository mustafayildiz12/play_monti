import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
}
