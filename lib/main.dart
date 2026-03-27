import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uyir_maruthuvam_new/core/widgets/restartwidget.dart';

import 'package:uyir_maruthuvam_new/features/auth/auth_gate.dart';
import 'package:uyir_maruthuvam_new/core/services/notification_services.dart';
import 'package:uyir_maruthuvam_new/features/auth/screens/welcome_screen.dart';
import 'package:uyir_maruthuvam_new/providers/favorites_provider.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:provider/provider.dart';
import 'providers/locale_provider.dart';
import 'l10n/app_localizations.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
    RestartWidget(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: localeProvider),

          ChangeNotifierProvider(
            create: (_) => FavoritesProvider()..startListening(),
          ),
        ],
        child: const MyApp(),
      ),
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
