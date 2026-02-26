import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/auth_services/Welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Uyir Maruthuvam",
      home: WelcomeScreen(),
    );
  }
}
