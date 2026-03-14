import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/model/appointment_model.dart';

class AppointmentTable extends StatelessWidget {
  final DateTime selectedDate;

  const AppointmentTable({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final List<Appointment> appointments = [
      Appointment(
        patientName: "Arun",
        age: 30,
        appointmentDate: DateTime(2026, 3, 4),
        slotTime: "10:00 - 10:15",
        isPaid: true,
        isCompleted: false,
      ),
      Appointment(
        patientName: "Kumar",
        age: 45,
        appointmentDate: DateTime(2026, 3, 4),
        slotTime: "10:15 - 10:30",
        isPaid: false,
        isCompleted: false,
      ),
      Appointment(
        patientName: "Ravi",
        age: 50,
        appointmentDate: DateTime(2026, 3, 5),
        slotTime: "11:00 - 11:15",
        isPaid: true,
        isCompleted: true,
      ),
    ];

    final filtered = appointments.where((appointment) {
      return appointment.appointmentDate.year == selectedDate.year &&
          appointment.appointmentDate.month == selectedDate.month &&
          appointment.appointmentDate.day == selectedDate.day;
    }).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text("No appointments for this day"));
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final appt = filtered[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Text(
                appt.patientName[0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              "${appt.patientName} (${appt.age})",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(appt.slotTime),
            trailing: Column(
              mainAxisSize: MainAxisSize.min, // ✅ IMPORTANT
              children: [
                Icon(
                  appt.isPaid ? Icons.check_circle : Icons.cancel,
                  color: appt.isPaid ? Colors.green : Colors.red,
                  size: 20,
                ),
                const SizedBox(height: 2),
                Icon(
                  appt.isCompleted ? Icons.done_all : Icons.hourglass_bottom,
                  color: appt.isCompleted ? Colors.blue : Colors.orange,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
