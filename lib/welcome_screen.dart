import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/auth_services/auth_gate.dart';
import 'package:uyir_maruthuvam_new/locale_provider.dart';
import 'package:uyir_maruthuvam_new/main.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [

          /// CENTER CONTENT
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/welcome.jpg', height: 120),

                const SizedBox(height: 20),

                const Text(
                  "Uyir Maruthuvam",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),

                const SizedBox(height: 10),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Healing with care, connecting lives.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// LANGUAGE BUTTON (BOTTOM LEFT)
          Positioned(
            bottom: 30,
            left: 20,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.language, size: 28),
              onSelected: (value) {

                if (value == "en") {
                  context.read<LocaleProvider>().setLocale('en');
                }

                if (value == "ta") {
                  context.read<LocaleProvider>().setLocale('ta');
                }

              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: "en",
                  child: Text("English"),
                ),
                PopupMenuItem(
                  value: "ta",
                  child: Text("தமிழ்"),
                ),
              ],
            )
          ),

          /// SKIP BUTTON (BOTTOM RIGHT)
          Positioned(
            bottom: 30,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AuthGate(),
                  ),
                );
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}