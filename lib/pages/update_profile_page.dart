import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

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
              Stack(
                children: [
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
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.amber,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get
                      .back(), // tıklandığında değişiklikleri kaydedip geri git
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Save Changes",
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
              Form(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                children: [
                    TextFormField(
                      cursorColor: Colors.amber,
                      decoration: InputDecoration(
                          label: Text("bio"),
                          prefixIcon: Icon(Icons.text_snippet),
                          prefixIconColor: Colors.black,
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      cursorColor: Colors.amber,
                      decoration: InputDecoration(
                          label: Text("User name"),
                          prefixIcon: Icon(Icons.person),
                          prefixIconColor: Colors.black,
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      cursorColor: Colors.amber,
                      decoration: InputDecoration(
                          label: Text("Password"),
                          prefixIcon: Icon(Icons.fingerprint),
                          prefixIconColor: Colors.black,
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ))),
                    ),
                ],
              ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
