import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentService {

  static Stream<QuerySnapshot> getAppointmentsForDate({
    required String doctorId,
    required DateTime date,
  }) {
    DateTime start = DateTime(date.year, date.month, date.day);
    DateTime end = start.add(const Duration(days: 1));

    return FirebaseFirestore.instance
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('date', isGreaterThanOrEqualTo: start)   // ✅ FIXED
        .where('date', isLessThan: end)                 // ✅ FIXED
        .snapshots();
  }
}