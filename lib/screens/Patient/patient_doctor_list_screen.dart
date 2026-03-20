import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import 'package:uyir_maruthuvam_new/screens/Appointments/patient_view_doctor_screen.dart';


class PatientDoctorListScreen extends StatefulWidget {
  const PatientDoctorListScreen({super.key});

  @override
  State<PatientDoctorListScreen> createState() =>
      _PatientDoctorListScreenState();
}

class _PatientDoctorListScreenState
    extends State<PatientDoctorListScreen> {

  double? patientLat;
  double? patientLng;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      patientLat = position.latitude;
      patientLng = position.longitude;
    });
  }

  Stream<QuerySnapshot> getDoctors() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'doctor') // ✅ FILTER
        .where('profileCompleted', isEqualTo: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctors"),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: getDoctors(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No doctors available"));
          }

          final doctors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {

              final doc = doctors[index];
              final data = doc.data() as Map<String, dynamic>;

              final name = data['name'] ?? "";
              final specialization = data['specialization'] ?? "";
              final experience = data['experience'] ?? "";
              final imageUrl = data['imageUrl'] ?? "";
              final latitude = data['latitude'];
              final longitude = data['longitude'];

              double? distance;

              if (patientLat != null && latitude != null) {
                distance = Geolocator.distanceBetween(
                  patientLat!,
                  patientLng!,
                  latitude,
                  longitude,
                ) / 1000;
              }

              return Card(
                margin: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : null,
                    child: imageUrl.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),

                  title: Text(name),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(specialization),
                      Text("$experience yrs experience"),

                      if (distance != null)
                        Text(
                          "${distance.toStringAsFixed(1)} km away",
                          style: const TextStyle(color: Colors.blue),
                        ),
                    ],
                  ),

                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PatientViewDocterScreen(
                          doctorId: doc.id, // ✅ PASS ID
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}