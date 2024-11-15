import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);
  User get user => _auth.currentUser!;

  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  Future<void> signUpMethod({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        print("The password is too weak.");
      } else if (e.code == "email-already-in-use") {
        print("The account already exists");
      }
      showSnackBar(context, e.message!);
    }
  }

  // Modified loginWithEmail with progress indicator
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Show a progress indicator
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Attempt to sign in
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Dismiss the progress indicator
      Navigator.pop(context);

      // Navigate to the Home Screen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const HomeScreen(), // Update to your Home Screen
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Dismiss the progress indicator if error occurs
      Navigator.pop(context);

      // Handle error and show snack bar
      showSnackBar(context, e.message!);
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}

// Show Snack Bar Helper Function
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
