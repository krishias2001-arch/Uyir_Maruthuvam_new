import 'package:cloud_firestore/cloud_firestore.dart';

class PatientModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int age;
  final String gender;
  final Timestamp? createdAt;
final String? imageUrl;
  PatientModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.gender,
    required this.imageUrl,
    this.createdAt,
  });

  /// Convert model → Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  /// Convert Firestore → model
  factory PatientModel.fromMap(Map<String, dynamic> map, String docId) {
    return PatientModel(
      id: docId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      createdAt: map['createdAt'] as Timestamp?,
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}