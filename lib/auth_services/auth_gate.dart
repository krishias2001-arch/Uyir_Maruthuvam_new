import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uyir_maruthuvam_new/auth_services/login_screen.dart';
import 'package:uyir_maruthuvam_new/screens/Doctor/Doctor_main_screen.dart';
import 'package:uyir_maruthuvam_new/screens/Doctor/doctor_profile_setup_screen.dart';
import 'package:uyir_maruthuvam_new/screens/Patient/patient_main_screen.dart';
import 'package:uyir_maruthuvam_new/screens/Patient/patient_profile_setup_screen.dart';
import 'package:uyir_maruthuvam_new/screens/role_selection_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return LoginScreen(onSignupTap: () {});
        }

        final user = snapshot.data!;

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, roleSnapshot) {

            if (!roleSnapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            final data =
            roleSnapshot.data!.data() as Map<String, dynamic>?;
            final role = data?['role'];
            final profileCompleted = data?['profileCompleted'] ?? false;

            if (role == null) {
              return const RoleSelectionScreen();
            }

            if (!profileCompleted) {

              if (role == "doctor") {
                return const DoctorProfileSetupScreen();
              }

              return const PatientProfileSetupScreen();
            }

            if (role == "doctor") {
              return const DoctorMainScreen();
            }

            return PatientMainScreen(
              username: data?['name'] ?? "User",
            );
          },
        );
      },
    );
  }
}