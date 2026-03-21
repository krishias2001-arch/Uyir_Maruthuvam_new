class AppointmentModel {
  final String id;
  final String doctorId;
  final String patientId;
  final DateTime date;
  final String status;

  AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'patientId': patientId,
      'date': date.toIso8601String(),
      'status': status,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map, String id) {
    return AppointmentModel(
      id: id,
      doctorId: map['doctorId'] ?? '',
      patientId: map['patientId'] ?? '',
      date: DateTime.parse(map['date']),
      status: map['status'] ?? 'pending',
    );
  }
}