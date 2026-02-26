import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/auth_services/login_screen.dart';
import 'package:uyir_maruthuvam_new/auth_services/signup_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showLogin = true;

  void toggleAuth() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: showLogin
            ? LoginScreen(key: const ValueKey('login'), onSignupTap: toggleAuth)
            : SignupScreen(
                key: const ValueKey('signup'),
                onLoginTap: toggleAuth,
              ),
      ),
    );
  }
}
