import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser!.uid;

  CollectionReference get _favRef =>
      _firestore.collection('users').doc(userId).collection('favorites');

  // Add favorite
  Future<void> addFavorite(Map<String, dynamic> doctor) async {
    await _favRef.doc(doctor['doctorId']).set(doctor);
  }

  // Remove favorite
  Future<void> removeFavorite(String doctorId) async {
    await _favRef.doc(doctorId).delete();
  }

  // Stream favorites (REAL-TIME)
  Stream<QuerySnapshot> getFavorites() {
    return _favRef.snapshots();
  }
}