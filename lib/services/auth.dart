import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scuffedgram/screens/home_screen.dart';

class AuthService {

  final FirebaseAuth _auth;

  AuthService(this._auth);
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> logIn(String email, String password, context) async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('Logged In');
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => home_screen()));
    } on FirebaseAuthException catch (e) {
      catchError(context, e);
    }
  }

  Future<void> register(String email, String password, String fullName, context) async {
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print('Registered successfully');
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => home_screen()));
    } on FirebaseAuthException catch (e) {
      catchError(context, e);
    }
  }

  catchError(context, e) {
    final code = e.code;

    if(code == 'invalid-email') {
      e = "Please enter a valid email.";
    } else if(code == 'user-disabled') {
      e = "Your account was disabled.";
    } else if(code == 'user-not-found') {
      e = "Please sign up to create an account or log in with Google.";
    } else if(code == 'wrong-password') {
      e = "Your password is incorrect.";
    } else if(code == 'too-many-requests') {
      e = "Account access blocked. Try again later.";
    } else if(code == 'email-already-in-use') {
      e = " You already have an account.";
    } else if(code == 'operation-not-allowed') {
      e = "Your account is not enable yet.";
    } else if(code == 'weak-password') {
      e = "Please create a stonger password.";
    }

    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Text(e),
      );
    });
  }
}