import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ta.dart';

abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ta')
  ];

  String get login;
  String get welcome;
  String get welcomeBack;
  String get logInToAccount;
  String get phoneNumber;
  String get sendOtp;
  String get dontHaveAccount;
  String get signUp;
  String get orContinueWith;
  String get google;
  String get apple;
  String get joinUsToday;
  String get createYourAccount;
  String get email;
  String get userName;
  String get password;
  String get confirmPassword;
  String get createAccount;
  String get alreadyHaveAccount;
  String get welcomeToUyirMaruthuvam;
  String get selectRole;
  String get continueAsPatient;
  String get continueAsDoctor;
  String get healingWithCare;
  String get skip;
  String get home;
  String get search;
  String get schedule;
  String get profile;
  String get settings;
  String get medicalRecords;
  String get medicalHistory;
  String get logout;
  String hello(String username);
  String get bestDoctors;
  String get bookAppointment;
  String get noDoctorsAvailable;
  String get searchDoctors;
  String get searchHint;
  String get all;
  String get dental;
  String get heart;
  String get eye;
  String get brain;
  String get ear;
  String get noDoctorsFound;
  String get upcoming;
  String get completed;
  String get cancelled;
  String get myProfile;
  String get editProfile;
  String get changePassword;
  String get patientName;
  String get language;
  String get todaySummary;
  String get total;
  String get pending;
  String get confirmed;
  String get clinic;
  String get specialization;
  String get availability;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ta': return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale".'
  );
}
