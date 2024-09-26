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
    apiKey: 'AIzaSyBf9f1cUemNzqdBTtyjbQw6p3E8FcU2LKI',
    appId: '1:925273350036:web:a6ceb80009626596167981',
    messagingSenderId: '925273350036',
    projectId: 'comments-app-2509',
    authDomain: 'comments-app-2509.firebaseapp.com',
    storageBucket: 'comments-app-2509.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB0rvBvMOoO1WvRtjPJSOif07u5W3uUn2I',
    appId: '1:925273350036:android:2410538dbb96f297167981',
    messagingSenderId: '925273350036',
    projectId: 'comments-app-2509',
    storageBucket: 'comments-app-2509.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC47w214Y0epd4E2bdB-BvNr-G1SXW7QQo',
    appId: '1:925273350036:ios:8cf9798f68b87b2f167981',
    messagingSenderId: '925273350036',
    projectId: 'comments-app-2509',
    storageBucket: 'comments-app-2509.appspot.com',
    iosBundleId: 'com.example.comments',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC47w214Y0epd4E2bdB-BvNr-G1SXW7QQo',
    appId: '1:925273350036:ios:8cf9798f68b87b2f167981',
    messagingSenderId: '925273350036',
    projectId: 'comments-app-2509',
    storageBucket: 'comments-app-2509.appspot.com',
    iosBundleId: 'com.example.comments',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBf9f1cUemNzqdBTtyjbQw6p3E8FcU2LKI',
    appId: '1:925273350036:web:454bd242af497bb6167981',
    messagingSenderId: '925273350036',
    projectId: 'comments-app-2509',
    authDomain: 'comments-app-2509.firebaseapp.com',
    storageBucket: 'comments-app-2509.appspot.com',
  );
}
