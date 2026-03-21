import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uyir_maruthuvam_new/features/auth/screens/login_screen.dart';
import 'package:uyir_maruthuvam_new/features/doctor/screens/doctor_main_screen.dart';
import 'package:uyir_maruthuvam_new/features/doctor/screens/doctor_profile_setup_screen.dart';
import 'package:uyir_maruthuvam_new/features/patient/patient_main_screen.dart';
import 'package:uyir_maruthuvam_new/features/patient/patient_profile_setup_screen.dart';
import 'package:uyir_maruthuvam_new/features/role/role_selection_screen.dart';
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

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, roleSnapshot) {

            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (roleSnapshot.hasError) {
              return const Scaffold(
                body: Center(child: Text("Something went wrong")),
              );
            }

            if (!roleSnapshot.hasData || !roleSnapshot.data!.exists) {
              return const RoleSelectionScreen();
            }

            final data = roleSnapshot.data!.data() as Map<String, dynamic>;
            final role = data['role'];
            final profileCompleted = data['profileCompleted'] ?? false;

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
              username: data['name'] ?? "User",
            );
          },
        );
      },
    );
  }
}
