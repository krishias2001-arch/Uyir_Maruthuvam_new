import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/model/appointment_model.dart';

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
          return CircularProgressIndicator();
        }

        var docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {

            var data = docs[index];

            return ListTile(
              title: Text(data['time']),
              subtitle: Text(data['status']),
                trailing:ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('appointments')
                        .doc(docs[index].id)
                        .update({
                      "status": "approved"
                    });
                  },
                  child: Text("Confirm"),
                )
            );
          },
        );
      },
    );
  }
}
