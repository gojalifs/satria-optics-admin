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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBSgnxi-xYBjpnWNdBJLei8ZqBpZySNgNs',
    appId: '1:891468843174:android:18bb2bc1a058bf64e58c67',
    messagingSenderId: '891468843174',
    projectId: 'satria-jaya-optik',
    storageBucket: 'satria-jaya-optik.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAf6rAjIs7Ql7ki5cU8TDVSgyj2fZERr-A',
    appId: '1:891468843174:ios:4c6dd8eda817a7c1e58c67',
    messagingSenderId: '891468843174',
    projectId: 'satria-jaya-optik',
    storageBucket: 'satria-jaya-optik.appspot.com',
    androidClientId: '891468843174-1mreo26vpsg0ee1a1gkbklnpo9m4rblh.apps.googleusercontent.com',
    iosClientId: '891468843174-f7tsisq6h7jtahgqobiaq7bh58srjo2b.apps.googleusercontent.com',
    iosBundleId: 'com.satria.dev.m.satriaOptikAdmin',
  );
}
