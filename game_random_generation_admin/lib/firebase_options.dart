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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAYK_A7iKAIqu1tSowwxppjQdD3eRXhPPc',
    appId: '1:690466063253:web:da85de49fb30429699ec9c',
    messagingSenderId: '690466063253',
    projectId: 'game-random-generation',
    authDomain: 'game-random-generation.firebaseapp.com',
    storageBucket: 'game-random-generation.appspot.com',
    measurementId: 'G-WYYMZYY614',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB0E92I3aNtjh2eOvGWX8Ee9CltzimWnqU',
    appId: '1:690466063253:android:938675e0d1bd0b9a99ec9c',
    messagingSenderId: '690466063253',
    projectId: 'game-random-generation',
    storageBucket: 'game-random-generation.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyADtJggbexVVRf6Rnp8y9GgnEO5bV625MA',
    appId: '1:690466063253:ios:d7aa72520fd6f32299ec9c',
    messagingSenderId: '690466063253',
    projectId: 'game-random-generation',
    storageBucket: 'game-random-generation.appspot.com',
    iosClientId: '690466063253-jo2e73n0q4tkcnqbdh8vaptsae1q412h.apps.googleusercontent.com',
    iosBundleId: 'com.example.gameRandomGenerationAdmin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyADtJggbexVVRf6Rnp8y9GgnEO5bV625MA',
    appId: '1:690466063253:ios:caf1de80215ede8099ec9c',
    messagingSenderId: '690466063253',
    projectId: 'game-random-generation',
    storageBucket: 'game-random-generation.appspot.com',
    iosClientId: '690466063253-15en1dphda25lpvbl8h3d7vipqasrjaf.apps.googleusercontent.com',
    iosBundleId: 'com.example.gameRandomGenerationAdmin.RunnerTests',
  );
}
