import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/helpers/modals_helper.dart';

class AuthService {
  User? loggedIn() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<UserCredential?> signUp(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ModalsHelper.snackbar(context, 'User with this email already exists');
      } else {
        ModalsHelper.snackbar(context, 'Erros occurred, please try again');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<UserCredential?> signIn(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ModalsHelper.snackbar(context, 'No account found with that username');
      } else if (e.code == 'wrong-password') {
        ModalsHelper.snackbar(context, 'Password is incorrect');
      }
    }
    return null;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
