import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/features/doctor/widgets/appointment_table.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/widgets/weekly_calander.dart';

class DoctorScheduleScreen extends StatefulWidget {
  const DoctorScheduleScreen({super.key});

  @override
  State<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    String doctorId = FirebaseAuth.instance.currentUser!.uid;
    
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Schedule"), centerTitle: true),
      body: Column(
        children: [
          WeeklyCalendar(
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
              });
            },
          ),

          const SizedBox(height: 10),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "appointments for Selected Date",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: AppointmentTable(
              selectedDate: selectedDate,
              doctorId: doctorId,
            ),
          ),
        ],
      ),
    );
  }
}
