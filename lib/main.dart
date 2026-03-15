import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uyir_maruthuvam_new/auth_services/auth_gate.dart';
import 'package:uyir_maruthuvam_new/services/notification_services.dart';
import 'package:uyir_maruthuvam_new/welcome_screen.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state =
    context.findAncestorStateOfType<_MyAppState>();
    state?.changeLanguage(locale);
  }

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

  Locale _locale = const Locale('en');

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "Uyir Maruthuvam",

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),

      locale: _locale,

      supportedLocales: const [
        Locale('en'),
        Locale('ta'),
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: const WelcomeScreen(),
    );
  }
}