import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:uyir_maruthuvam_new/core/services/patient_service.dart';
import 'package:uyir_maruthuvam_new/data/models/patient_model.dart';
import 'package:uyir_maruthuvam_new/features/appointments/screens/notification_screen.dart';
import 'dart:io';
import 'package:uyir_maruthuvam_new/features/patient/screens/patient_view_doctor_screen.dart';
import 'package:uyir_maruthuvam_new/l10n/app_localizations.dart';
import 'package:uyir_maruthuvam_new/providers/favorites_provider.dart';
import '../../../core/services/notification_services.dart';

class PatientHomeScreen extends StatefulWidget {


  const PatientHomeScreen({super.key, });

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  File? _imageFile;
  Future<PatientModel?>? _patientFuture;
  final NotificationService _notificationService = NotificationService();

  String? imageUrl;
  @override
  void initState() {
    super.initState();

    final uid = _notificationService.getCurrentUserId();

    if (uid != null) {
      _patientFuture = PatientService().getPatient(uid);
    }
  }
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<FavoritesProvider>(context);
    final favoriteIds = provider.favoriteIds.toList();

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
                       CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.redAccent,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : (imageUrl?.isNotEmpty == true
                            ? NetworkImage(imageUrl!) as ImageProvider
                            : null),
                        child: imageUrl?.isEmpty == true
                            ? const Icon(Icons.person, size: 50, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 15),
                      FutureBuilder<PatientModel?>(
                        future: _patientFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text("Loading...");
                          }

                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Text("Hello");
                          }

                          final patient = snapshot.data!;

                          return Text(
                            l10n.hello(patient.name),
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
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
                                      builder: (context) => const NotificationScreen(),
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
            child:  StreamBuilder<QuerySnapshot>(
              stream: favoriteIds.isEmpty
                  ? null
                  : FirebaseFirestore.instance
                  .collection('users')
                  .where(FieldPath.documentId, whereIn: favoriteIds)
                  .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var doctors = snapshot.data!.docs;
                    var favoriteDoctors = doctors.where((doc) {
                      return provider.isFavorite(doc.id);
                    }).toList();
                    
                    if (favoriteDoctors.isEmpty) {
                      return Center(
                        child: Text(
                          "No favorite doctors yet",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: favoriteDoctors.length,
                      itemBuilder: (context, index) {
                        var doctorData = favoriteDoctors[index].data() as Map<String, dynamic>;
                        String doctorId = favoriteDoctors[index].id;
                        String doctorName = doctorData['name'] ?? 'Unknown Doctor';
                        String specialization = doctorData['specialization'] ?? 'General';
                        String doctorImageUrl = doctorData['imageUrl'] ?? '';
                        double rating = (doctorData['rating'] ?? 0).toDouble();
                        bool isFavorite = provider.isFavorite(doctorId);
                        return Container(
                          height: 320,
                          width: 200,
                          margin: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
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
                                          builder: (context) => PatientViewDoctorScreen(
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
                                        child: doctorImageUrl.isNotEmpty
                                            ? Image.network(
                                                doctorImageUrl,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              )
                                            : const Icon(
                                                Icons.person,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      height: 35,
                                      width: 35,
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
                                      child: IconButton(
                                        icon: Icon(
                                          isFavorite ? Icons.favorite : Icons.favorite_border,
                                          color: Colors.redAccent,
                                          size: 18,
                                        ),
                                        onPressed: () async {
                                          try {
                                            await provider.toggleFavorite(doctorId);
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("Failed to remove favorite")),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doctorName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.8),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
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
                                        const Icon(Icons.star, color: Colors.amber, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          rating == 0 ? "0.0" : rating.toStringAsFixed(1),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: SizedBox(
                                  height: 35,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PatientViewDoctorScreen(doctorId: doctorId),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                    ),
                                    child: Text(
                                      l10n.bookAppointment,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
            )
          )
        ]
      ),
      )
    );
  }

  }

