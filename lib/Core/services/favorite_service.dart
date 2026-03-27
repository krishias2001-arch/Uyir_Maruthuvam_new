import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Add to favorites
  Future<void> addToFavorites(String userId, String doctorId) async {
    await _firestore.collection('users').doc(userId).update({
      'favorites': FieldValue.arrayUnion([doctorId])
    });
  }

  /// 🔹 Remove from favorites
  Future<void> removeFromFavorites(String userId, String doctorId) async {
    await _firestore.collection('users').doc(userId).update({
      'favorites': FieldValue.arrayRemove([doctorId])
    });
  }

  /// 🔹 Toggle favorite (best method to reuse)
  Future<void> toggleFavorite(
      String userId,
      String doctorId,
      bool isFavorite,
      ) async {
    if (isFavorite) {
      await removeFromFavorites(userId, doctorId);
    } else {
      await addToFavorites(userId, doctorId);
    }
  }
}