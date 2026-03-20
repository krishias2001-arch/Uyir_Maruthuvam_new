import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/screens/Doctor/bottomnavigationbar/doctor_home_screen.dart';
import 'package:uyir_maruthuvam_new/screens/Doctor/bottomnavigationbar/doctor_schedule_screen.dart';
import 'package:uyir_maruthuvam_new/main.dart';

class DoctorMainScreen extends StatefulWidget {
  const DoctorMainScreen({super.key});

  @override
  State<DoctorMainScreen> createState() => _DoctorMainScreenState();
}

class _DoctorMainScreenState extends State<DoctorMainScreen> {
  int _selectedIndex = 0;

  void _onLogout() async {
    // Use the static restart method
    MyApp.restartApp();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      DoctorHomeScreen(onLogout: _onLogout),
            DoctorScheduleScreen(),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black26,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Schedule",
          ),
        ],
      ),
    );
  }
}
