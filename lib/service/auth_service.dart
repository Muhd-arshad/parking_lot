import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:parkinglot/constants/flushbar.dart';

class AuthService{
     Future<User?> signin(
      String emailAddress, String password, context) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      log('usercrediant =$credential');
      return credential.user;
    } on SocketException {
      log ("No Internet Connection");
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      if (e.code == 'invalid-credential') {
        // log('user not found');
         showFlushbar(context, 'Email or Password Incorrect.');
        return null;
      } else if (e.code == 'wrong-password') {
         showFlushbar(context, 'Wrong password provided for that user.');
        return null;
      }
    }
    return null;
  }
   Future<User?> userSignup(
      String emailAddress, String password, context) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showFlushbar(context,'The password provided is too weak.');
        return null;
      } else if (e.code == 'email-already-in-use') {
        showFlushbar(context, 'The account already exists for that email.');
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
    return null;
  }
}