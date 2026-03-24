import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/features/Patient/screens/addreviewbottomsheet.dart';
import 'package:uyir_maruthuvam_new/features/appointments/appointment_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PatientViewDoctorScreen extends StatefulWidget {
  final String doctorId;

  const PatientViewDoctorScreen({super.key, required this.doctorId});
  
  static const List<String> imgs = [
    "assets/images/doctor1.jpg",
    "assets/images/doctor2.jpg",
    "assets/images/doctor3.jpg",
    "assets/images/doctor4.jpg",
  ];

  @override
  State<PatientViewDoctorScreen> createState() => _PatientViewDoctorScreenState();
}

class _PatientViewDoctorScreenState extends State<PatientViewDoctorScreen> {
  Map<String, dynamic>? doctorData;
  bool isLoading = true;
  List<Map<String, dynamic>> reviews = [];
  double averageRating = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);

    await Future.wait([
      fetchDoctor(),
      fetchReviews(),
    ]);

    setState(() => isLoading = false);
  }


  Future<void> fetchDoctor() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.doctorId)
          .get();

      if (doc.exists) {
        setState(() {
          doctorData = doc.data();
        });
      }
    } catch (e) {
      print("Error fetching doctor: $e");
      setState(() {
        doctorData = {};
      });
    }
  }
  Future<void> fetchReviews() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.doctorId)
          .collection('reviews')
          .orderBy('timestamp', descending: true)
          .get();

      reviews = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      // ⭐ average calculation (all users)
      if (reviews.isNotEmpty) {
        double total = 0;
        for (var r in reviews) {
          total += (r['rating'] as num?)?.toDouble() ?? 0;
        }
        averageRating = total / reviews.length;
      } else {
        averageRating = 0;
      }

      setState(() {});
    } catch (e) {
      print("Error fetching reviews: $e");
      setState(() {
        reviews = [];
        averageRating = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
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
                          Icons.arrow_back,
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
                        Builder(
                          builder: (context) {
                            final imageUrl = doctorData?['imageUrl'];
                            return CircleAvatar(
                              radius: 40,
                              backgroundImage: imageUrl != null && imageUrl != ""
                                  ? NetworkImage(imageUrl)
                                  : null,
                              child: (imageUrl == null || imageUrl == "")
                                  ? Icon(Icons.person)
                                  : null,
                            );
                          },
                        ),
                        SizedBox(height: 15),
                    Text(doctorData?['name'] ?? "No Name",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 15),
              Text(doctorData?['specialization'] ?? "",
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
                  Text(
                    "About Doctor",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                      doctorData?['about'] ?? "",
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
                      Spacer(),

                      TextButton(
                          onPressed: () async {
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => AddReviewBottomSheet(
                                doctorId: widget.doctorId,
                              ),
                            );
                            fetchReviews();
                          },
                        child: Text("Add Review"),
                        // 👈 ADD THIS
                      ),

                      SizedBox(width: 10),
                      Icon(Icons.star, color: Colors.amber),
              Text(
                reviews.isEmpty ? "0.0" : averageRating.toStringAsFixed(1),
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
                    height: 180,
                    child: reviews.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.rate_review, color: Colors.grey),
                          SizedBox(height: 5),
                          Text("No reviews yet"),
                        ],
                      ),
                    )
                        : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final review = reviews[index];

                          final timestamp = review['timestamp'] as Timestamp?;
                          final date = timestamp?.toDate();

                          return Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 4),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                  title: Text(review['patientName'] ?? "Anonymous"),
                                  subtitle: Text(
                                    date != null
                                        ? "${date.day}/${date.month}/${date.year}"
                                        : "Unknown",
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.star, color: Colors.amber),
                                      Text(
                                        (review['rating'] ?? 0).toString(),
                                      ),
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
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFFF0EEFA),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.redAccent,
                        size: 30,
                      ),
                    ),
                    title: Text(doctorData?['clinic'] ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                    subtitle: Text(doctorData?['clinicAddress'] ?? "")
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
            BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2),
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
        Text("₹${doctorData?['fee'] ?? 0}",
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
                  MaterialPageRoute(builder: (context) => AppointmentScreen(doctorId: widget.doctorId)),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
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
}
