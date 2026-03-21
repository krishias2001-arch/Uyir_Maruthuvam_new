import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uyir_maruthuvam_new/data/models/appointment_model.dart';


class AppointmentRepository {
  final FirebaseFirestore firestore;

  AppointmentRepository(this.firestore);

  Future<void> createAppointment(AppointmentModel appointment) async {
    await firestore.collection('appointments').add(
      appointment.toMap(),
    );
  }
  Future<List<AppointmentModel>> getAppointmentsForDate(DateTime date) async {
    return [];
  }

  Stream<List<AppointmentModel>> getAppointments(String userId) {
    return firestore
        .collection('appointments')
        .where('patientId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
        .toList());
  }
}