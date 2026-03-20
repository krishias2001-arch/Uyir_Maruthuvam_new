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
    "assets/images/doctor1.jpg",
    "assets/images/doctor2.jpg",
    "assets/images/doctor3.jpg",
    "assets/images/doctor4.jpg",
  ];

  @override
  State<PatientViewDocterScreen> createState() =>
      _PatientViewDocterScreenState();
}

class _PatientViewDocterScreenState extends State<PatientViewDocterScreen>
    with WidgetsBindingObserver {
  Future<void> addReview({
    required String doctorId,
    required String patientName,
    required String comment,
    required double rating,
  }) async {
    if (comment.trim().isEmpty) return; // basic validation

    await FirebaseFirestore.instance
        .collection('users')
        .doc(doctorId)
        .collection('reviews')
        .add({
      'patientName': patientName,
      'comment': comment,
      'rating': rating,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
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

                  final lat = doctor['latitude'];
                  final lng = doctor['longitude'];

                  final Uri uri = Uri.parse(
                    "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng",
                  );

                  if (await canLaunchUrl(uri)) {
                    await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication, // 🔥 VERY IMPORTANT
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Could not open Google Maps")),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void _showReviewDialog() {
    TextEditingController commentController = TextEditingController();
    double rating = 4;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Write Review"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: "Enter your review",
                ),
              ),
              SizedBox(height: 10),

              /// ⭐ Rating Dropdown
              StatefulBuilder(
                builder: (context, setState) {
                  return DropdownButton<double>(
                    value: rating,
                    items: [1, 2, 3, 4, 5]
                        .map((e) => DropdownMenuItem(
                      value: e.toDouble(),
                      child: Text("$e Stars"),
                    ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        rating = val!;
                      });
                    },
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await addReview(
                  doctorId: widget.doctorId,
                  patientName: "Patient", // later replace with user name
                  comment: commentController.text,
                  rating: rating,
                );

                Navigator.pop(context);
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        // 🔄 Force rebuild when returning from Maps
      });
    }
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

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Scaffold(
              body: Center(child: Text("Reconnecting...")),
            );
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
            backgroundColor: Colors.orangeAccent.withOpacity(0.7),
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
                                Icons.arrow_back_ios_new_outlined,
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
                                    : AssetImage("assets/images/doctor1.jpg") as ImageProvider,
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
                                  color: available ? Colors.green : Colors.yellow,
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
                            Text(" "),
                            Spacer(),

                            /// ✍️ WRITE REVIEW BUTTON
                            TextButton(
                              onPressed: () {
                                _showReviewDialog();
                              },
                              child: Text(
                                "Write Review",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 180,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.doctorId)
                                .collection('reviews')
                                .orderBy('timestamp', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {

                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return Center(child: Text("No reviews yet"));
                              }

                              final reviews = snapshot.data!.docs;

                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: reviews.length,
                                itemBuilder: (context, index) {
                                  final review = reviews[index];

                                  return Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width / 1.4,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(color: Colors.black12, blurRadius: 4),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          leading: CircleAvatar(
                                            child: Icon(Icons.person),
                                          ),
                                          title: Text(review['patientName'] ?? "Anonymous"),
                                          subtitle: Text("Recent"),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.star, color: Colors.amber),
                                              Text("${review['rating']}"),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          review['comment'] ?? "",
                                          style: TextStyle(color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  );
                                },
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