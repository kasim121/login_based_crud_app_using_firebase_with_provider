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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDBGdCtgDFP9o9EjY6xqDxoScx7pUwSYHI',
    appId: '1:900484616611:web:81405cbdfdd75842beca16',
    messagingSenderId: '900484616611',
    projectId: 'authapp-504f6',
    authDomain: 'authapp-504f6.firebaseapp.com',
    storageBucket: 'authapp-504f6.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCaxf_eofbwIakNfwniZ4pbopxG0i8Ty1w',
    appId: '1:900484616611:android:04e954222850b62ebeca16',
    messagingSenderId: '900484616611',
    projectId: 'authapp-504f6',
    storageBucket: 'authapp-504f6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDAgiDlHbvwKLgzSDmvp9lp8x_d5BNJZpU',
    appId: '1:900484616611:ios:061d1b33c52a61ddbeca16',
    messagingSenderId: '900484616611',
    projectId: 'authapp-504f6',
    storageBucket: 'authapp-504f6.firebasestorage.app',
    iosBundleId: 'com.example.authApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDBGdCtgDFP9o9EjY6xqDxoScx7pUwSYHI',
    appId: '1:900484616611:web:ba3fdfb937211ef6beca16',
    messagingSenderId: '900484616611',
    projectId: 'authapp-504f6',
    authDomain: 'authapp-504f6.firebaseapp.com',
    storageBucket: 'authapp-504f6.firebasestorage.app',
  );
}
