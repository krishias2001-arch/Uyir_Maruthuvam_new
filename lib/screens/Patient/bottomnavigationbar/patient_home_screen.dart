import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uyir_maruthuvam_new/screens/Appointments/patient_view_doctor_screen.dart';
import 'package:uyir_maruthuvam_new/screens/Doctor/widgets/notification_bell.dart';
import 'package:uyir_maruthuvam_new/l10n/app_localizations.dart';

import '../../../services/notification_services.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final NotificationService _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                          "assets/images/patient_profile.jpg",
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        l10n.hello(widget.username),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      StreamBuilder<int>(
                        stream: _notificationService.getUnreadNotificationsCount(
                          _notificationService.getCurrentUserId() ?? '',
                        ),
                        builder: (context, snapshot) {
                          int unreadCount = snapshot.data ?? 0;
                          
                          return Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const NotificationBell(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF2F8FF),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        spreadRadius: 4,
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Icon(
                                      unreadCount > 0 
                                          ? Icons.notifications_active 
                                          : Icons.notifications_outlined,
                                      color: Colors.redAccent,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                              if (unreadCount > 0)
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Text(
                                      unreadCount > 99 ? '99+' : unreadCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              l10n.bestDoctors,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
          SizedBox(
            height: 360,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'doctor')
                  .where('profileCompleted', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var doctors = snapshot.data!.docs;

                if (doctors.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.noDoctorsAvailable,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    var doctorData = doctors[index].data() as Map<String, dynamic>;
                    String doctorId = doctors[index].id;
                    String doctorName = doctorData['name'] ?? 'Unknown Doctor';
                    String specialization = doctorData['specialization'] ?? 'General';

                    return Container(
                      height: 320,
                      width: 200,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 2,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PatientViewDocterScreen(
                                          doctorId: doctorId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    child: Container(
                                      height: 160,
                                      width: 200,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.person,
                                        size: 80,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    height: 45,
                                    width: 45,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          spreadRadius: 2,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.favorite_outline,
                                      color: Colors.redAccent,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doctorName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    specialization,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber),
                                      const SizedBox(width: 5),
                                      Text(
                                        "4.9",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 50,
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                                PatientViewDocterScreen(doctorId: doctorId),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(l10n.bookAppointment),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    )
    );
  }
}
