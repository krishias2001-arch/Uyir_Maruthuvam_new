import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uyir_maruthuvam_new/services/fcm_service.dart';

class GoogleAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: '968357194494-rs9pa89ve7r9bab1i1r6anu6ief9h09r.apps.googleusercontent.com',
  );

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await _auth.signInWithCredential(
      credential,
    );

    User? user = userCredential.user;

    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'name': user.displayName,
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await FCMService.saveToken();

    return userCredential;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
