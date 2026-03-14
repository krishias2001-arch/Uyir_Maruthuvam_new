class Appointment {
  final String patientName;
  final int age;
  final DateTime appointmentDate;
  final String slotTime;
  final bool isPaid;
  final bool isCompleted;

  Appointment({
    required this.patientName,
    required this.age,
    required this.appointmentDate,
    required this.slotTime,
    required this.isPaid,
    required this.isCompleted,
  });
}
