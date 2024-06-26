// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBwkfX4QroHs6H0cZDiRnagt0iQhscuZ_c',
    appId: '1:733930354320:web:e74ef3eb9ff18712ffca15',
    messagingSenderId: '733930354320',
    projectId: 'petcare-5eaec',
    authDomain: 'petcare-5eaec.firebaseapp.com',
    storageBucket: 'petcare-5eaec.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBU6DsoVQAlH152rfYED3IvbpQrgJH4AJw',
    appId: '1:733930354320:android:02b99579befb78a8ffca15',
    messagingSenderId: '733930354320',
    projectId: 'petcare-5eaec',
    storageBucket: 'petcare-5eaec.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOEEmywPG2iGxkjVHjpQugPtI4zVq3C4U',
    appId: '1:733930354320:ios:20852238a15dcb9cffca15',
    messagingSenderId: '733930354320',
    projectId: 'petcare-5eaec',
    storageBucket: 'petcare-5eaec.appspot.com',
    iosBundleId: 'com.example.petCare',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBOEEmywPG2iGxkjVHjpQugPtI4zVq3C4U',
    appId: '1:733930354320:ios:20852238a15dcb9cffca15',
    messagingSenderId: '733930354320',
    projectId: 'petcare-5eaec',
    storageBucket: 'petcare-5eaec.appspot.com',
    iosBundleId: 'com.example.petCare',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBwkfX4QroHs6H0cZDiRnagt0iQhscuZ_c',
    appId: '1:733930354320:web:03dbc497065458fcffca15',
    messagingSenderId: '733930354320',
    projectId: 'petcare-5eaec',
    authDomain: 'petcare-5eaec.firebaseapp.com',
    storageBucket: 'petcare-5eaec.appspot.com',
  );
}
