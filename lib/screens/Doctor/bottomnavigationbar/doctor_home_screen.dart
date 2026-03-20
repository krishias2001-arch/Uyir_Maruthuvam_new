import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/screens/Doctor/doctor_profile_setup_screen.dart';
import 'package:uyir_maruthuvam_new/screens/Doctor/widgets/doctor_profile_card.dart';
import 'package:uyir_maruthuvam_new/screens/Doctor/widgets/notification_bell.dart';
import 'package:uyir_maruthuvam_new/screens/Doctor/widgets/todaysummarycard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uyir_maruthuvam_new/common widget/language_selector.dart';
import 'package:uyir_maruthuvam_new/auth_services/google_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uyir_maruthuvam_new/model/appointment_services.dart';
class DoctorHomeScreen extends StatefulWidget {
  final VoidCallback? onLogout;
   const DoctorHomeScreen({super.key, this.onLogout});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  
  // Add a stream key to force refresh

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(const Duration(days: 1));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uyir Maruthuvam"),
          actions: const [
            NotificationBell(),
          ]
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
                    MaterialPageRoute(builder: (_) => const DoctorProfileSetupScreen()),
                  ).then((_) {
                    // Force refresh when returning from profile setup
                    setState(() {});
                    // Also refresh the stream
                    setState(() {
                      // This will trigger a rebuild
                    });
                  });
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

              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: Text("Profile not found"));
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;

                  return DoctorProfileCard(
                    clinicName: data['clinic'] ?? '',
                    doctorName: data['name'] ?? '',
                    specialization: data['specialization'] ?? '',
                    imageUrl: data['imageUrl'] ?? '',
                    isAvailable: data['isAvailable'] ?? false,
                  );
                },
              ),

              const SizedBox(height: 10),

              StreamBuilder<QuerySnapshot>(
                stream: AppointmentService.getAppointmentsForDate(
                  doctorId: FirebaseAuth.instance.currentUser!.uid,
                  date: DateTime.now(),
                ),
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text("Error loading appointments"));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const TodaySummaryCard(total: 0, pending: 0, confirmed: 0);
                  }

                  int total = snapshot.data!.docs.length;
                  int pending = 0;
                  int confirmed = 0;

                  for (var doc in snapshot.data!.docs) {
                    final data = doc.data() as Map<String, dynamic>;

                    if (data['status'] == 'pending') pending++;
                    if (data['status'] == 'confirmed') confirmed++;
                  }

                  return TodaySummaryCard(
                    total: total,
                    pending: pending,
                    confirmed: confirmed,
                  );
                },
              )

            ],
          ),
        )

    );
  }
}
