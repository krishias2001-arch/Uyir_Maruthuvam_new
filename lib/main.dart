import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:uyir_maruthuvam_new/auth_services/auth_gate.dart';
import 'package:uyir_maruthuvam_new/services/notification_services.dart';
import 'package:uyir_maruthuvam_new/welcome_screen.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:provider/provider.dart';
import 'locale_provider.dart';
import 'l10n/app_localizations.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Initialization error: $e");
  }

  await NotificationService().init();

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  // ✅ CREATE provider
  final localeProvider = LocaleProvider();

  // ✅ LOAD saved language BEFORE UI starts
  await localeProvider.loadLocale();

  // ✅ PASS provider to app
  runApp(
    ChangeNotifierProvider.value(
      value: localeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  const MyApp({super.key});



  static void restartApp() {
    final navigator = navigatorKey.currentState;
    if (navigator != null) {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthGate()),
            (route) => false,
      );
    }
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {






  @override
  Widget build(BuildContext context) {

    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "Uyir Maruthuvam",

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),

      // ✅ USE provider here
      locale: localeProvider.locale,

      supportedLocales: AppLocalizations.supportedLocales,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: const WelcomeScreen(),
    );
  }
}
