import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/screens/Doctor/doctor_profile_setup_screen.dart';
import 'package:uyir_maruthuvam_new/screens/Doctor/widgets/doctor_profile_card.dart';
import 'package:uyir_maruthuvam_new/screens/Doctor/widgets/notification_bell.dart';
import 'package:uyir_maruthuvam_new/screens/Doctor/widgets/todaysummarycard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uyir_maruthuvam_new/widget/language_selector.dart';
import 'package:uyir_maruthuvam_new/auth_services/google_auth.dart';

class DoctorHomeScreen extends StatefulWidget {
  final VoidCallback? onLogout;
   const DoctorHomeScreen({super.key, this.onLogout});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uyir Maruthuvam"),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NotificationBell()),
                  );
                },
              ),

              // 🔴 Notification Badge
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '3', // notification count
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.displayName ?? "Doctor"),
              accountEmail: Text(user?.email ?? "No Email"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage:
                user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                child: user?.photoURL == null
                    ? const Icon(Icons.person, size: 40, color: Colors.redAccent)
                    : null,
              )
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
                onTap: () {
                  Navigator.pop(context); // close drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DoctorProfileSetupScreen()),
                  );
                }
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                // Navigate to settings screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text("Language"),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const LanguageSelector(),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                await GoogleAuth().signOut();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DoctorProfileCard(),
            SizedBox(height: 10),
            TodaySummaryCard(total: 15, pending: 3, confirmed: 12),
          ],
        ),
      ),
    );
  }
}
