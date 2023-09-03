import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Userr {
  final String bio;
  final String email;
  final String password;
  final String photoURL;
  final String uid;
  final String username;
  final String fcmToken;

  Userr({
    required this.bio,
    required this.password,
    required this.uid,
    required this.username,
    required this.email,
    required this.photoURL,
    required this.fcmToken,
  });
}

class UserService {
  static Userr? currentUser;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> fetchCurrentUser() async {
    final currentUserUID = _firebaseAuth.currentUser?.uid;

    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUID)
        .get();

    final data = snapshot.data() as Map<String, dynamic>;
    final username = data['username'].toString();
    final email = data['email'].toString();
    final bio = data['bio'].toString();
    final password = data['password'].toString();
    final uid = data['uid'].toString();
    final photoURL = data['photoURL'].toString();
    final fcmToken = data["fcmToken"].toString();

    currentUser = Userr(
      uid: uid,
      username: username,
      email: email,
      photoURL: photoURL,
      bio: bio,
      password: password,
      fcmToken: fcmToken,
    );
  }
}
