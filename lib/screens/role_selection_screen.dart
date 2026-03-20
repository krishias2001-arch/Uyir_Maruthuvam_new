import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uyir_maruthuvam_new/l10n/app_localizations.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.jpg', height: 100),
              const SizedBox(height: 30),
              Text(
                l10n.welcomeToUyirMaruthuvam,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.selectRole,
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 40),

              // Patient Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;

                    if (user == null) return;

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .set({
                      'role': 'patient',
                      'profileCompleted': false,
                    }, SetOptions(merge: true));
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    l10n.continueAsPatient,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Doctor Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;

                    if (user == null) return;

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .set({
                      'role': 'doctor',
                      'profileCompleted': false,
                    }, SetOptions(merge: true));
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    l10n.continueAsDoctor,
                    style: const TextStyle(fontSize: 16, color: Colors.redAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
        ),
    );
  }
}
