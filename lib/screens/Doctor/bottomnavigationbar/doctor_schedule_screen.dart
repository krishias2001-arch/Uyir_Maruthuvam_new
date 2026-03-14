import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/model/appointment_model.dart';
import 'package:uyir_maruthuvam_new/widget/weekly_calander.dart';

class DoctorScheduleScreen extends StatefulWidget {
  const DoctorScheduleScreen({super.key});

  @override
  State<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  DateTime selectedDate = DateTime.now();

  final List<Appointment> allAppointments = [
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
    Appointment(
      patientName: "Ravi",
      age: 50,
      appointmentDate: DateTime.now().add(const Duration(days: 1)),
      slotTime: "11:00 - 11:15",
      isPaid: true,
      isCompleted: true,
    ),
  ];

  List<Appointment> getFilteredAppointments() {
    final filtered = allAppointments
        .where(
          (a) =>
              a.appointmentDate.year == selectedDate.year &&
              a.appointmentDate.month == selectedDate.month &&
              a.appointmentDate.day == selectedDate.day,
        )
        .toList();

    filtered.sort((a, b) => a.slotTime.compareTo(b.slotTime));

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredAppointments = getFilteredAppointments();

    final completedCount = filteredAppointments
        .where((a) => a.isCompleted)
        .length;

    final paidCount = filteredAppointments.where((a) => a.isPaid).length;

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

          /// Summary Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ${filteredAppointments.length}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Completed: $completedCount",
                  style: const TextStyle(color: Colors.blue),
                ),
                Text(
                  "Paid: $paidCount",
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
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
                : ListView.builder(
                    itemCount: filteredAppointments.length,
                    itemBuilder: (context, index) {
                      final appt = filteredAppointments[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                appt.isPaid ? Icons.check_circle : Icons.cancel,
                                color: appt.isPaid ? Colors.green : Colors.red,
                              ),
                              const SizedBox(height: 4),
                              Icon(
                                appt.isCompleted
                                    ? Icons.done_all
                                    : Icons.hourglass_bottom,
                                color: appt.isCompleted
                                    ? Colors.blue
                                    : Colors.orange,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
