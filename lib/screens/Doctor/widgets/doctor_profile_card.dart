import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoctorProfileCard extends StatefulWidget {

  final String clinicName;
  final String doctorName;
  final String specialization;
  final String imageUrl;
  final bool isAvailable;

  const DoctorProfileCard({
  super.key,
  required this.clinicName,
  required this.doctorName,
  required this.specialization,
  required this.imageUrl,
  required this.isAvailable,
  });
  @override
  State<DoctorProfileCard> createState() => _DoctorProfileCardState();
}

class _DoctorProfileCardState extends State<DoctorProfileCard> {
  late bool isAvailable;

  @override
  void initState() {
    super.initState();
    isAvailable = widget.isAvailable;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8)],
      ),
      child: Stack(
        children: [
          // 🔹 Circle Avatar (Top Left)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              width: 110,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), // rounded rectangle
                color: widget.imageUrl.isEmpty ? Colors.grey[300] : null,
              ),
              child: widget.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.imageUrl,
                        width: 110,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.person, size: 50, color: Colors.grey),
                          );
                        },
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
            ),
          ),

          // 🔹 Doctor Details
          Padding(
            padding: const EdgeInsets.only(left: 150, top: 20, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.clinicName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  widget.doctorName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  widget.specialization,
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      isAvailable ? "Available" : "Not Available",
                      style: TextStyle(
                        color: isAvailable ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: isAvailable,
                      onChanged: (value) async {
                        setState(() {
                          isAvailable = value;
                        });

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          'isAvailable': value,
                        });
                      },
                      activeThumbColor: Colors.green, // ON circle
                      activeTrackColor: Colors.greenAccent,
                      inactiveThumbColor: Colors.red, // OFF circle
                      inactiveTrackColor: Colors.redAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
