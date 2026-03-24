import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uyir_maruthuvam_new/data/models/patient_model.dart';

class PatientService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPatient(PatientModel patient) async {
    await _firestore
        .collection('patients')
        .doc(patient.id)
        .set(patient.toMap());
  }

  Future<PatientModel?> getPatient(String id) async {
    final doc = await _firestore.collection('patients').doc(id).get();

    if (doc.exists && doc.data() != null) {
      return PatientModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }
}