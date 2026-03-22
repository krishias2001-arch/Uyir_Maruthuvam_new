import 'package:flutter/material.dart';
import '../core/services/favorites_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoritesService _service = FavoritesService();

  Set<String> _favoriteIds = {};
  Set<String> get favoriteIds => _favoriteIds;

  // Listen to Firestore (REAL-TIME)
  void startListening() {
    _service.getFavorites().listen((snapshot) {
      _favoriteIds =
          snapshot.docs.map((doc) => doc.id).toSet();
      notifyListeners();
    });
  }

  bool isFavorite(String doctorId) {
    return _favoriteIds.contains(doctorId);
  }

  Future<void> toggleFavorite(Map<String, dynamic> doctor) async {
    final doctorId = doctor['doctorId'];

    if (isFavorite(doctorId)) {
      await _service.removeFavorite(doctorId);
    } else {
      await _service.addFavorite(doctor);
    }
  }
}