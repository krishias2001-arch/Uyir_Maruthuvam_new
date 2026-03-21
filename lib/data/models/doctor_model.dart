import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String id;
  final String name;
  final String specialization;
  final int experience;
  final double fee;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final bool isAvailable;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.fee,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.isAvailable,
  });

  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Doctor(
      id: doc.id,
      name: data['name'] ?? '',
      specialization: data['specialization'] ?? '',
      experience: data['experience'] ?? 0,
      fee: (data['fee'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      latitude: data['location']?['latitude'] ?? 0.0,
      longitude: data['location']?['longitude'] ?? 0.0,
      isAvailable: data['isAvailable'] ?? false,
    );
  }
}