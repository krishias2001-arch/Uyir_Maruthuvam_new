import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/services/favorite_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoriteService _service = FavoriteService();

  Set<String> _favoriteIds = {};
  Set<String> get favoriteIds => _favoriteIds;

  String get _userId => FirebaseAuth.instance.currentUser!.uid;

  /// 🔥 REAL-TIME LISTENER (correct for your structure)
  void startListening() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .snapshots()
        .listen((snapshot) {
      final data = snapshot.data();

      if (data != null && data['favorites'] != null) {
        _favoriteIds = Set<String>.from(data['favorites']);
      } else {
        _favoriteIds = {};
      }

      notifyListeners();
    });
  }

  /// ✅ Check favorite
  bool isFavorite(String doctorId) {
    return _favoriteIds.contains(doctorId);
  }

  /// ✅ Toggle favorite
  Future<void> toggleFavorite(String doctorId) async {
    final isFav = isFavorite(doctorId);

    await _service.toggleFavorite(
      _userId,
      doctorId,
      isFav,
    );
  }
}