import 'package:flutter/material.dart';

class DoctorProfileCard extends StatefulWidget {
  const DoctorProfileCard({super.key});

  @override
  State<DoctorProfileCard> createState() => _DoctorProfileCardState();
}

class _DoctorProfileCardState extends State<DoctorProfileCard> {
  bool isAvailable = true;

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
                image: DecorationImage(
                  image: AssetImage("images/doctor1.jpg"),
                  fit: BoxFit.cover,
                ),
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
                  "Uyir Maruthuvam Clinic",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Dr. Krishna",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  "General Physician",
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
                      onChanged: (value) {
                        setState(() {
                          isAvailable = value;
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
