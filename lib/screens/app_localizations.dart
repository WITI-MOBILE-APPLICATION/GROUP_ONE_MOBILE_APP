// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class AppLocalizations {
//   final Locale locale;
//   late Map<String, String> _localizedStrings;

//   AppLocalizations(this.locale);

//   // Helper method to keep the code in the widgets concise
//   static AppLocalizations? of(BuildContext context) {
//     return Localizations.of<AppLocalizations>(context, AppLocalizations);
//   }

//   // Static member to have a simple access to the delegate from the MaterialApp
//   static const LocalizationsDelegate<AppLocalizations> delegate =
//       _AppLocalizationsDelegate();

//   Future<bool> load() async {
//     // Load the language JSON file from the "lang" folder
//     // String jsonString =
//     //     await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
//     // Change this line
//     String jsonString =
//         await rootBundle.loadString('lang/${locale.languageCode}.json');
//     Map<String, dynamic> jsonMap = json.decode(jsonString);

//     _localizedStrings = jsonMap.map((key, value) {
//       return MapEntry(key, value.toString());
//     });

//     return true;
//   }

//   // This method will be called from every widget that needs a localized text
//   String translate(String key) {
//     return _localizedStrings[key] ?? key;
//   }
// }

// // LocalizationsDelegate is a factory for a set of localized resources
// class _AppLocalizationsDelegate
//     extends LocalizationsDelegate<AppLocalizations> {
//   const _AppLocalizationsDelegate();

//   @override
//   bool isSupported(Locale locale) {
//     // Include all supported language codes here
//     return ['en', 'de', 'hi', 'id', 'it', 'ja', 'ko']
//         .contains(locale.languageCode);
//   }

//   @override
//   Future<AppLocalizations> load(Locale locale) async {
//     // AppLocalizations class is where the JSON loading actually runs
//     AppLocalizations localizations = AppLocalizations(locale);
//     await localizations.load();
//     return localizations;
//   }

//   @override
//   bool shouldReload(_AppLocalizationsDelegate old) => false;
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'de', 'hi', 'id', 'it', 'ja', 'ko']
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
