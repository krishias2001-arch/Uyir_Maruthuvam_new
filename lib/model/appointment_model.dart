class Appointment {
  String patientName;
  int age;
  DateTime appointmentDate;
  String slotTime;
  bool isPaid;
  bool isCompleted;

  Appointment({
    required this.patientName,
    required this.age,
    required this.appointmentDate,
    required this.slotTime,
    required this.isPaid,
    required this.isCompleted,
  });
}
