import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/features/patient/bottomnavigationbar/doctor_search_screen.dart';
import 'package:uyir_maruthuvam_new/features/patient/patient_profile_screen.dart';
import 'package:uyir_maruthuvam_new/features/patient/patient_profile_setup_screen.dart';
import 'package:uyir_maruthuvam_new/features/patient/patient_storage_screen.dart';
import 'package:uyir_maruthuvam_new/features/auth/services/google_auth.dart';
import 'bottomnavigationbar/patient_home_screen.dart';
import 'bottomnavigationbar/schedule_screen.dart';
import 'package:uyir_maruthuvam_new/l10n/app_localizations.dart';

class PatientMainScreen extends StatefulWidget {
  final String username;
  const PatientMainScreen({super.key, required this.username});

  @override
  State<PatientMainScreen> createState() => _PatientMainScreenState();
}

class _PatientMainScreenState extends State<PatientMainScreen> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      PatientHomeScreen(username: widget.username),
      const DoctorSearchScreen(),
      const ScheduleScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black26,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home_filled), label: l10n.home),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.search_circle_fill),
            label: l10n.search,

          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            label: l10n.schedule,
          ),
        ],
      ),
      appBar: AppBar(title: const Text("Uyir Maruthuvam")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(l10n.patientName),
              accountEmail: const Text("patient@email.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.redAccent),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(l10n.profile),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PatientProfileSetupScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(l10n.settings),
              onTap: () {
                // Navigate to settings screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(l10n.medicalRecords),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PatientStorageScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_information),
              title: Text(l10n.medicalHistory),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PatientStorageScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(l10n.logout),
              onTap: () async {
                await GoogleAuth().signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
