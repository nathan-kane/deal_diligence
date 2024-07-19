// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  var vapidKey =
      "BPeAY_n11fc6jVMd5deMLLHJ51ntWfW4wzt9qjh3B0KFbC5pPkR3sn3t_QRxTg3zDSCVLLtZ2kHxxvR4jL2EoNk";

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDBIaLXzl5tF2QNTN58s2iPDI--GLr7bqo',
    appId: '1:394692266013:web:0b5da830c03cc9d1a51ef4',
    messagingSenderId: '394692266013',
    projectId: 'deal-diligence-5de73',
    authDomain: 'deal-diligence-5de73.firebaseapp.com',
    storageBucket: 'deal-diligence-5de73.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCoxOwgic8wnLEzB2koLr44cOHKnDNmtOM',
    appId: '1:394692266013:android:dfbaae290896d469a51ef4',
    messagingSenderId: '394692266013',
    projectId: 'deal-diligence-5de73',
    storageBucket: 'deal-diligence-5de73.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAGpz3g039bEFz8hKgnQxruaRIBXySPPwU',
    appId: '1:394692266013:ios:8c1deda3b2ab741ca51ef4',
    messagingSenderId: '394692266013',
    projectId: 'deal-diligence-5de73',
    storageBucket: 'deal-diligence-5de73.appspot.com',
    iosBundleId: 'com.example.dealDiligence',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAGpz3g039bEFz8hKgnQxruaRIBXySPPwU',
    appId: '1:394692266013:ios:b3cd459ab7e0e6b5a51ef4',
    messagingSenderId: '394692266013',
    projectId: 'deal-diligence-5de73',
    storageBucket: 'deal-diligence-5de73.appspot.com',
    iosBundleId: 'com.example.dealDiligence.RunnerTests',
  );
}
