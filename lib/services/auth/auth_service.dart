import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password, String userName) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      //create a file for users collection

      String defaultPhotoURL = 'https://firebasestorage.googleapis.com/v0/b/chitchat-flutter-9998f.appspot.com/o/default.png?alt=media&token=557d082f-310f-4100-a817-c7bad67674cc';
      String defaultBio= "Hi, it's my bio!👋";

      _firebaseFirestore.collection("users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        "email": email,
        "password": password,
        "username": userName,
        'photoURL': defaultPhotoURL,
        "bio": defaultBio,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<String?> getUsername() async {
    final String userId = _firebaseAuth.currentUser!.uid;

    final DocumentSnapshot snapshot = await _firebaseFirestore.collection('users').doc(userId).get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    final String? username = data?["username"];
    return username;
  }

}
