import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/model/appointment_model.dart';

class AppointmentTable extends StatelessWidget {
  final List<Appointment> appointments;

  const AppointmentTable({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    List<Appointment> sortedList = List.from(appointments);
    sortedList.sort((a, b) => a.slotTime.compareTo(b.slotTime));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Token')),
          DataColumn(label: Text('Slot')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Age')),
          DataColumn(label: Text('Paid')),
          DataColumn(label: Text('Complete')),
        ],
        rows: List.generate(sortedList.length, (index) {
          final appointment = sortedList[index];

          return DataRow(
            cells: [
              DataCell(Text('${index + 1}')),
              DataCell(Text(appointment.slotTime)),
              DataCell(Text(appointment.patientName)),
              DataCell(Text('${appointment.age}')),
              DataCell(
                Icon(
                  appointment.isPaid ? Icons.check_circle : Icons.cancel,
                  color: appointment.isPaid ? Colors.green : Colors.red,
                ),
              ),
              DataCell(
                Icon(appointment.isCompleted ? Icons.done : Icons.pending),
              ),
            ],
          );
        }),
      ),
    );
  }
}
