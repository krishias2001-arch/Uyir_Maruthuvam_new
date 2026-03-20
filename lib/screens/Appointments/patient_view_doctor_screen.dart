import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:uyir_maruthuvam_new/Services/Map%20services/Clinic_location-map_screen.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:uyir_maruthuvam_new/screens/Appointments/appointment_screen.dart';
class PatientViewDocterScreen extends StatefulWidget {
  const PatientViewDocterScreen({super.key, required this.doctorId});

  final String doctorId;

  static const List<String> imgs = [
    "images/doctor1.jpg",
    "images/doctor2.jpg",
    "images/doctor3.jpg",
    "images/doctor4.jpg",
  ];

  @override
  State<PatientViewDocterScreen> createState() =>
      _PatientViewDocterScreenState();
}

class _PatientViewDocterScreenState extends State<PatientViewDocterScreen> {
  void _openLocationOptions(Map<String, dynamic> doctor) {
    final lat = doctor['latitude'];
    final lng = doctor['longitude'];

    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location not available")),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 150,
          child: Column(
            children: [

              /// 🗺 View inside app
              ListTile(
                leading: const Icon(Icons.map),
                title: const Text("View on Map"),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClinicLocationMapScreen(
                        latitude: lat,
                        longitude: lng,
                      ),
                    ),
                  );
                },
              ),

              /// 🚗 Google Maps Navigation
              ListTile(
                leading: const Icon(Icons.navigation),
                title: const Text("Get Directions"),
                onTap: () async {
                  Navigator.pop(context);

                  final url =
                      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";

                  await launchUrl(Uri.parse(url));
                },
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.doctorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading doctor data"));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Doctor not found"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          final hospital = data?['clinic'] ?? 'No hospital';
          final address = data?['clinicAddress'] ?? '';
          final lat = data?['latitude'];
          final lng = data?['longitude'];
          final name = data?['name'] ?? 'No Name';
          final specialization = data?['specialization'] ?? 'General';
          final about = data?['about'] ?? 'No description';
          final fee = data?['fee'] ?? 0;
          final clinic = data?['clinic'] ?? 'No clinic';

          final imageUrl = data?['imageUrl'];
          bool available = data?['available'] ?? false;




          return Scaffold(
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.more_vert,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: (data?['imageUrl'] != null &&
                                    data!['imageUrl'].toString().isNotEmpty)
                                    ? NetworkImage(data['imageUrl'])
                                    : AssetImage("images/doctor1.jpg") as ImageProvider,
                              ),
                              SizedBox(height: 15),
                              Text("Dr. $name",
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                available ? "Available Now" : "Doctor Offline",
                                style: TextStyle(
                                  color: available ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(specialization,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.call,
                                      color: Colors.redAccent,
                                      size: 25,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      CupertinoIcons.videocam_circle_fill,
                                      color: Colors.redAccent,
                                      size: 25,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      CupertinoIcons.chat_bubble_text_fill,
                                      color: Colors.redAccent,
                                      size: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 20, left: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(about,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "My aim is good medication for all every people deserve for better medical exposure",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "Reviews",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.star, color: Colors.amber),
                            Text(
                              "4.9",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "See all",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 160,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: SizedBox(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 1.4,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: CircleAvatar(
                                            radius: 25,
                                            backgroundImage: AssetImage(
                                                PatientViewDocterScreen
                                                    .imgs[index])
                                        ),
                                        title: Text(
                                          "Dr.Docter Name",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text("1 day ago"),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            Icon(Icons.star,
                                                color: Colors.amber),
                                            Text(
                                              "4.9",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "Many thanks to Dr.Dear,He is a great and professional docter",
                                          style: TextStyle(
                                              color: Colors.black54),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Location",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.location_on, color: Colors.redAccent),
                          title: const Text("Clinic Location"),
                          subtitle: Text(data?['clinicAddress'] ?? "No address"),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            _openLocationOptions(data!); // ✅ FIXED
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.all(15),
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 4, spreadRadius: 2),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Consultation Fee",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text("₹$fee",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.redAccent.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AppointmentScreen(doctorId: widget.doctorId),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: available ? Colors.redAccent : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "book appointment",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}