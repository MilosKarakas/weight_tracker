import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/helpers/modals_helper.dart';

class AuthService {
  User? loggedIn() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<UserCredential?> signUp(
      BuildContext context, String email, String password) async {
    ModalsHelper.snackbar(context, 'Signing up',
        backgroundColor: Colors.deepPurple.shade200);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ModalsHelper.snackbar(context, 'User with this email already exists');
      } else {
        ModalsHelper.snackbar(context, 'Errors occurred, please try again');
      }
    } catch (e) {
      print(e);
    }
    ModalsHelper.snackbar(
        context, 'Could not sign up. Please try again later.');
    return null;
  }

  Future<UserCredential?> signIn(
      BuildContext context, String email, String password) async {
    ModalsHelper.snackbar(context, 'Signing in',
        backgroundColor: Colors.deepPurple.shade200);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ModalsHelper.snackbar(context, 'No account found with that username');
      } else if (e.code == 'wrong-password') {
        ModalsHelper.snackbar(context, 'Password is incorrect');
      }
    }
    ModalsHelper.snackbar(
        context, 'Could not sign in. Please try again later.');
    return null;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<UserCredential?> signInAnonymously(BuildContext context) async {
    ModalsHelper.snackbar(context, 'Signing in',
        backgroundColor: Colors.deepPurple.shade200);
    try {
      final credential = await FirebaseAuth.instance.signInAnonymously();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      return credential;
    } on FirebaseAuthException catch (exception) {
      if (exception.code == 'operation-not-allowed') {
        ModalsHelper.snackbar(context,
            'Anonymous sign in is not available at the moment. Please try again later.');
        return null;
      }
    } catch (exception) {
      ModalsHelper.snackbar(
          context, 'Cannot sign in anonymously. Please try again later.');
      return null;
    }
    ModalsHelper.snackbar(
        context, 'Cannot sign in anonymously. Please try again later.');
    return null;
  }
}
