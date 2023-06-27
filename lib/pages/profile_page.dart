import 'package:chitchat/pages/update_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/profile_section.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {

  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final String email = _auth.currentUser!.email.toString();

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                    image: AssetImage("lib/assets/default.png"),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: _firestore.collection('users').doc(_auth.currentUser!.uid).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(
                      'Error',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    );
                  } else {
                    final username = snapshot.data!.get('username').toString();
                    return Text(
                      username,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    );
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                email,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get.to(()=> UpdateProfileScreen()),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    side: BorderSide.none,
                    shape: StadiumBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              ProfileSection(title: 'User Management', icon: Icons.person, onPress: (){},),
              ProfileSection(title: 'Log out', icon: Icons.logout, onPress: (){},),
            ],
          ),
        ),
      ),
    );
  }
}
