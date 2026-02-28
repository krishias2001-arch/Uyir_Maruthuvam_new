import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/model/appointment_model.dart';
import 'package:uyir_maruthuvam_new/widget/appointment_table.dart';
import 'package:uyir_maruthuvam_new/widget/weekly_calander.dart';

class DoctorScheduleScreen extends StatefulWidget {
  const DoctorScheduleScreen({super.key});

  @override
  State<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  DateTime selectedDate = DateTime.now();

  List<Appointment> allAppointments = [
    Appointment(
      patientName: "Arun",
      age: 30,
      appointmentDate: DateTime.now(),
      slotTime: "10:00 - 10:15",
      isPaid: true,
      isCompleted: false,
    ),
    Appointment(
      patientName: "Kumar",
      age: 45,
      appointmentDate: DateTime.now(),
      slotTime: "10:15 - 10:30",
      isPaid: false,
      isCompleted: false,
    ),
  ];

  List<Appointment> getFilteredAppointments() {
    return allAppointments
        .where(
          (a) =>
              a.appointmentDate.year == selectedDate.year &&
              a.appointmentDate.month == selectedDate.month &&
              a.appointmentDate.day == selectedDate.day,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredAppointments = getFilteredAppointments();

    return Scaffold(
      appBar: AppBar(title: const Text("Schedule")),
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
          Expanded(
            child: filteredAppointments.isEmpty
                ? const Center(
                    child: Text(
                      "No Appointments for this date",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : AppointmentTable(appointments: filteredAppointments),
          ),
        ],
      ),
    );
  }
}
