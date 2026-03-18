import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointmentTable extends StatelessWidget {
  final DateTime selectedDate;
  final String doctorId;

  const AppointmentTable({super.key, required this.selectedDate, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .snapshots(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var docs = snapshot.data!.docs;

        // Filter appointments by selected date
        var filteredDocs = docs.where((doc) {
          var appointmentDate = (doc['date'] as Timestamp).toDate();
          return appointmentDate.year == selectedDate.year &&
                 appointmentDate.month == selectedDate.month &&
                 appointmentDate.day == selectedDate.day;
        }).toList();

        if (filteredDocs.isEmpty) {
          return const Center(
            child: Text(
              "No Appointments for this date",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {

            var data = filteredDocs[index];
            var appointmentData = data.data();
            
            String patientId = appointmentData['patientId'] ?? '';
            String time = appointmentData['time'] ?? '';
            String status = appointmentData['status'] ?? 'pending';

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(patientId)
                  .get(),
              builder: (context, patientSnapshot) {
                String patientName = 'Unknown Patient';
                
                if (patientSnapshot.hasData && patientSnapshot.data!.exists) {
                  var patientData = patientSnapshot.data!.data() as Map<String, dynamic>?;
                  patientName = patientData?['name'] ?? 'Unknown Patient';
                }

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Text(
                        patientName.isNotEmpty ? patientName[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      patientName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(time),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: status == 'pending' ? Colors.orange : 
                                   status == 'approved' ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (status == 'pending') ...[
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              // Update appointment status
                              await FirebaseFirestore.instance
                                  .collection('appointments')
                                  .doc(data.id)
                                  .update({
                                "status": "approved"
                              });

                              // Create notification for patient
                              await FirebaseFirestore.instance
                                  .collection('notifications')
                                  .add({
                                'title': 'Appointment Approved',
                                'body': 'Your appointment has been approved for $time',
                                'userId': patientId,
                                'timestamp': Timestamp.now(),
                                'isRead': false,
                                'type': 'appointment',
                                'appointmentId': data.id,
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Confirm"),
                          ),
                          const SizedBox(width: 4),
                          ElevatedButton(
                            onPressed: () async {
                              // Update appointment status
                              await FirebaseFirestore.instance
                                  .collection('appointments')
                                  .doc(data.id)
                                  .update({
                                "status": "rejected"
                              });

                              // Create notification for patient
                              await FirebaseFirestore.instance
                                  .collection('notifications')
                                  .add({
                                'title': 'Appointment Rejected',
                                'body': 'Your appointment for $time has been rejected',
                                'userId': patientId,
                                'timestamp': Timestamp.now(),
                                'isRead': false,
                                'type': 'appointment',
                                'appointmentId': data.id,
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Reject"),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
