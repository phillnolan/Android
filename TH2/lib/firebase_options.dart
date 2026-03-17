import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBEvTcGr3r9d4M314Bm61Mu06aA1bv8s4Y',
    appId: '1:659618774475:web:008dd9b2ceb39209a7ca4e',
    messagingSenderId: '659618774475',
    projectId: 'note-app-3eba5',
    authDomain: 'note-app-3eba5.firebaseapp.com',
    storageBucket: 'note-app-3eba5.firebasestorage.app',
    measurementId: 'G-P6KVY397EY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBGDms28mle0e1IbshgACmpG37jB11uK28',
    appId: '1:659618774475:android:479c7d93ce993c1ca7ca4e',
    messagingSenderId: '659618774475',
    projectId: 'note-app-3eba5',
    storageBucket: 'note-app-3eba5.firebasestorage.app',
  );
}
