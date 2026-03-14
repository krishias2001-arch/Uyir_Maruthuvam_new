import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;

      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBbPcIFj8Qi9K0Z6Y2fuXpjUiL3ClMWejs',
    appId: '1:968357194494:web:294cc427e26a242b4d93af',
    messagingSenderId: '968357194494',
    projectId: 'uyirmaruthuvam-d3601',
    authDomain: 'uyirmaruthuvam-d3601.firebaseapp.com',
    storageBucket: 'uyirmaruthuvam-d3601.firebasestorage.app',
    measurementId: 'G-VZ2GCHNEVJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDdtptne2SEieXscQII1V_LOaKhMNUPk4k',
    appId: '1:968357194494:android:f84c439b1220b4564d93af',
    messagingSenderId: '968357194494',
    projectId: 'uyirmaruthuvam-d3601',
    storageBucket: 'uyirmaruthuvam-d3601.firebasestorage.app',
  );
}
